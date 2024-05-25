{
  lib,
  callPackage,
  vimPlugins,
  ...
}:
let
  inherit (lib) fileset;
  inherit (lib.attrsets) recursiveUpdate;

  neovimBuilder = callPackage ./builder.nix;

  minimal = noPlugins.override {
    treesitter-grammars = [ ];
    withPython3 = false;
    withNodeJs = false;
    withRuby = false;
  };

  noPlugins = neovimBuilder {
    nvim-src = fileset.toSource {
      root = ../../../.;
      fileset = fileset.unions [
        ../../../lua/common
        ../../../plugin
      ];
    };

    plugins = with vimPlugins; [
      lazy-nvim
      nvim-treesitter
      catppuccin-nvim
    ];
    luaRc = "";
  };

  full = neovimBuilder {
    nvim-src = fileset.toSource {
      root = ../../../.;
      fileset = fileset.unions [ ../../../lua/nobody ];
    };

    plugins = with vimPlugins; [
      lazy-nvim
      nvim-treesitter
      catppuccin-nvim
    ];
    luaRc = ''
      require("nobody")
    '';
  };
in
full.overrideAttrs (
  _: previousAttrs: {
    passthru = recursiveUpdate previousAttrs.passthru { inherit full noPlugins minimal; };
  }
)
