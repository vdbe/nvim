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

    plugins = [ ];
    luaRc = "";
  };

  comet = neovimBuilder {
    nvim-src = fileset.toSource {
      root = ../../../.;
      fileset = fileset.unions [
        ../../../lua/common
        ../../../lua/comet
      ];
    };

    plugins = with vimPlugins; [
      lazy-nvim

      astronvim
      astrocore
      astrolsp
      astroui
      astrocommunity

      nvim-lspconfig
      neoconf-nvim
      lspkind-nvim
      nvim-treesitter
      nvim-treesitter-textobjects

      nvim-cmp
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      cmp_luasnip
      friendly-snippets
      luasnip

      catppuccin-nvim
    ];
    luaRc = ''
      require("comet")
    '';
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
comet.overrideAttrs (
  _: previousAttrs: {
    passthru = recursiveUpdate previousAttrs.passthru {
      inherit
        full
        comet
        noPlugins
        minimal
        ;
    };
  }
)
