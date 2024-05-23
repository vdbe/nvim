{
  description = "My neovim config";

  inputs = {
    systems.url = "github:nix-systems/default";

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      systems = import inputs.systems;

      forSystem = system: fn: fn nixpkgs.legacyPackages.${system};
      forAllSystems = fn: nixpkgs.lib.genAttrs systems (system: forSystem system fn);
    in
    {
      apps = forAllSystems (pkgs: import ./nix/apps.nix { inherit self pkgs; });

      checks = forAllSystems (pkgs: import ./nix/checks.nix { inherit self pkgs; });

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

      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);

      packages = forAllSystems (
        pkgs:
        let
          inherit (self.legacyPackages.${pkgs.system}) neovim;
        in
        {
          inherit neovim;
          default = neovim;
        }
      );

      legacyPackages = forAllSystems (pkgs: import ./nix/pkgs { inherit pkgs; });
    };

  nixConfig = {
    extra-substituters = [ "https://vdbe.cachix.org" ];
    extra-trusted-public-keys = [ "vdbe.cachix.org-1:ID9DIbnE6jHyJlQiwS7L7tFULJd1dsxt2ODAWE94nts=" ];
  };
}
