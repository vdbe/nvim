{
  description = "My neovim config";

  inputs = {
    systems.url = "github:nix-systems/default";

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs: import ./nix/outputs.nix inputs;

  nixConfig = {
    extra-substituters = [ "https://vdbe.cachix.org" ];
    extra-trusted-public-keys = [ "vdbe.cachix.org-1:ID9DIbnE6jHyJlQiwS7L7tFULJd1dsxt2ODAWE94nts=" ];
  };
}
