{
  description = "A very basic flake";

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
  in {
    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          # nix
          self.formatter.${pkgs.system}
          deadnix
          nixd
          statix
        ];
      };
    });

    formatter = forAllSystems (pkgs: pkgs.alejandra);

    packages = forAllSystems (pkgs: rec {
      mynvim = import ./neovim.nix self pkgs;
      default = mynvim;
    });
  };
}
