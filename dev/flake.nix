{
  description = "A dev env for my neovim config";

  inputs = {
    systems.url = "github:nix-systems/default";

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { flake-parts, treefmt-nix, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ treefmt-nix.flakeModule ];
      flake = (import ../nix/outputs.nix inputs) // {
        formatter = { };
      };
      systems = [
        # systems for which you want to build the `perSystem` attributes
        "x86_64-linux"
        # ...
      ];
      perSystem =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          treefmt = {
            # Handled by pre-commit check
            flakeCheck = true;
            flakeFormatter = false;

            projectRoot = ./..;
            projectRootFile = "flake.nix";
            programs = {
              nixfmt-rfc-style.enable = true;
              deadnix.enable = true;
              statix.enable = true;

              mdsh.enable = true;

              stylua.enable = true;
            };

            settings = {
              global = {
                excludes = [ "./nix/sources/**" ];
              };
              formatter = {
                "typos" = {
                  command = lib.meta.getExe pkgs.typos;
                  includes = [ "*" ];
                };
              };
            };
          };

          devShells = {
            default = pkgs.mkShellNoCC {
              inherit (config.treefmt.build.devShell) nativeBuildInputs;
              packages = with pkgs; [
                npins

                # lua
                lua-language-server
                stylua
                selene

                # nix
                deadnix
                nixd
                statix

                # other
                typos
              ];
            };
          };

          packages = {
            treefmt = config.treefmt.build.wrapper;
          };

          formatter = config.treefmt.build.wrapper;
        };
    };

  nixConfig = {
    extra-substituters = [ "https://vdbe.cachix.org" ];
    extra-trusted-public-keys = [ "vdbe.cachix.org-1:ID9DIbnE6jHyJlQiwS7L7tFULJd1dsxt2ODAWE94nts=" ];
  };
}
