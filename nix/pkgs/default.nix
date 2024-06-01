{
  self ? null,
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
  ...
}:
let
  version = self.shortRev or self.dirtyShortRev or "unknown-dirty";

  packageSet = lib.makeScope pkgs.newScope (
    final:
    let
      inherit (final) callPackage;
      inherit (lib.attrsets) recurseIntoAttrs;
    in
    {
      neovim = callPackage ./neovim { inherit version; };
      vimPlugins = recurseIntoAttrs (callPackage ./vimPlugins { });
      tree-sitter-grammars = recurseIntoAttrs (callPackage ./tree-sitter-grammars { });
    }
  );
in
packageSet
