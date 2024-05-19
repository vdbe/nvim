{
  description = "My neovim config";

  inputs = {
    systems.url = "github:nix-systems/default";

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    systems = import inputs.systems;

    forSystem = system: fn: fn nixpkgs.legacyPackages.${system};
    forAllSystems = fn: nixpkgs.lib.genAttrs systems (system: forSystem system fn);

    mapAttrs' = f: set:
      builtins.listToAttrs (builtins.map (attr: f attr set.${attr}) (builtins.attrNames set));
    namePlugin = name: builtins.replaceStrings ["."] ["-"] name;

    pluginSources = mapAttrs' (n: v: {
      name = namePlugin n;
      value = v;
    }) (import ./nix/npins);

    mkPlugins = buildVimPlugin: (builtins.mapAttrs (n: v:
      buildVimPlugin {
        pname = n;
        version = v.version;
        src = v;
      })
    pluginSources);
  in {
    checks = forAllSystems (pkgs: import ./nix/checks.nix {inherit pkgs self;});

    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShellNoCC {
        packages =
          [
            # nix
            self.formatter.${pkgs.system}
          ]
          ++ (with pkgs; [
            npins

            # nix
            deadnix
            nixd
            statix
          ]);
      };
    });

    formatter = forAllSystems (pkgs: pkgs.alejandra);

    packages = forAllSystems (pkgs: let
      inherit (self.legacyPackages.${pkgs.system}) vimPlugins;

      mynvim = import ./nix/neovim.nix {
        inherit self vimPlugins pkgs;
      };
    in {
      inherit mynvim;
      default = mynvim;
    });

    legacyPackages = forAllSystems (pkgs: {
      vimPlugins =
        pkgs.lib.recursiveUpdate
        pkgs.vimPlugins
        (mkPlugins (pkgs.vimUtils.buildVimPlugin));
    });
  };
}
