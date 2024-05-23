{
  pkgs,
  lib ? pkgs.lib,
  ...
}:
let
  packageSet = lib.makeScope pkgs.newScope (
    final:
    let
      inherit (final) callPackage;
      inherit (lib.attrsets) recurseIntoAttrs;
    in
    {
      neovim = callPackage ./neovim { };
      vimPlugins = recurseIntoAttrs (callPackage ./vimPlugins { });
      tree-sitter-grammars = recurseIntoAttrs (callPackage ./tree-sitter-grammars { });
    }
  );
in
packageSet
