{ self, nixpkgs, ... }@inputs:
let
  systems = import inputs.systems;

  forSystem = system: fn: fn nixpkgs.legacyPackages.${system};
  forAllSystems = fn: nixpkgs.lib.genAttrs systems (system: forSystem system fn);
in
{
  apps = forAllSystems (pkgs: import ./apps.nix { inherit self pkgs; });

  checks = forAllSystems (pkgs: import ./checks.nix { inherit self pkgs; });

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

  legacyPackages = forAllSystems (pkgs: import ./pkgs { inherit self pkgs; });
}
