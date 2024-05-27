{
  pkgs,
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

    lspPackages = with pkgs; [
      # lua
      lua-language-server
      stylua
      selene
    ];

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
      none-ls-nvim
      neodev-nvim
      conform-nvim

      nvim-cmp
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      cmp_luasnip
      friendly-snippets
      luasnip

      nvim-dap
      cmp-dap
      nvim-dap-ui
      nvim-nio

      plenary-nvim
      catppuccin-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      which-key-nvim
      heirline-nvim
      nvim-autopairs
      gitsigns-nvim
    ];
    luaRc = ''
      require("comet")
    '';
  };

  example = neovimBuilder {
    nvim-src = fileset.toSource {
      root = ../../../.;
      fileset = fileset.unions [ ../../../lua/example ];
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
        example
        comet
        noPlugins
        minimal
        ;
    };
  }
)
