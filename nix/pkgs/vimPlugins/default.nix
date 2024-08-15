{
  lib,
  pkgs,
  callPackage,
  vimUtils ? pkgs.vimUtils,
  buildVimPlugin ? vimUtils.buildVimPlugin,
  ...
}:
let
  inherit (builtins) mapAttrs replaceStrings;
  inherit (lib.attrsets) mapAttrs' recursiveUpdate;
  inherit (lib.fixedPoints) extends;
  inherit (lib.strings) toLower;

  renamePlugin = name: replaceStrings [ "." ] [ "-" ] (toLower name);

  pluginSources = mapAttrs' (n: v: {
    name = renamePlugin n;
    value = recursiveUpdate {
      repository = {

        repo = n;
      };
    } v;
  }) (import ../../sources/plugins);

  mkPlugins = mapAttrs (
    n: v:
    buildVimPlugin {
      pname = v.repository.repo or v.originalName or n;
      version = v.version or v.revision;
      src = v;
    }
  );

  plugins = mkPlugins pluginSources;

  initialPackages = _: plugins;

  overrides = callPackage ./overrides.nix { };

  extensible-self = lib.makeExtensible (extends overrides initialPackages);
in
extensible-self
