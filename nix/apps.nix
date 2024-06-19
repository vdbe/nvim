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

  update-lazy-lock = pkgs.writeShellApplication {
    name = "update-lazy-lock";
    runtimeInputs = with pkgs; [
      neovim
      gitMinimal
    ];
    text = ''
      declare tmpdir
      tmpdir="$(mktemp -d)"

      # Setup nvim config
      mkdir -p "$tmpdir/.config"
      ln -s "$PWD" "$tmpdir/.config/nvim"

      # shellcheck disable=SC2046
      unset $(env | grep "^XDG_" | cut -d= -f1)

      HOME="$tmpdir" nvim --headless '+Lazy! update' '+qa!' 2>/dev/null

      unlink "$tmpdir/.config/nvim"
      rm -rf "$tmpdir"
    '';
  };

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

  update-all = pkgs.writeShellApplication {
    name = "update-sources";
    runtimeInputs = [
      update-sources
      update-lazy-lock
    ];
    text = ''
      set -e
      update-sources
      update-lazy-lock
    '';
  };

  apps = {
    update-all = {
      type = "app";
      program = lib.getExe update-all;
    };

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

    update-lazy-lock = {
      type = "app";
      program = lib.getExe update-lazy-lock;
    };
  };
in
apps
