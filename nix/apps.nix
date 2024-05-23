{
  pkgs,
  lib ? pkgs.lib,
  ...
}:
let
  sources = "nix/sources";

  mkUpdateSource =
    name: path:
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = with pkgs; [ npins ];
      text = ''
        npins --directory '${path}' update "$@"
      '';
    };

  update-plugins = mkUpdateSource "update-plugins" "${sources}/plugins";
  update-grammars = mkUpdateSource "update-grammars" "${sources}/grammars";

  update-sources = pkgs.writeShellApplication {
    name = "update-sources";
    runtimeInputs = [
      update-plugins
      update-grammars
    ];
    text = ''
      set -e
      update-plugins "$@"
      update-grammars "$@"
    '';
  };

  apps = {
    update-sources = {
      type = "app";
      program = lib.getExe update-sources;
    };
    update-plugins = {
      type = "app";
      program = lib.getExe update-plugins;
    };
    update-grammars = {
      type = "app";
      program = lib.getExe update-grammars;
    };
  };
in
apps
