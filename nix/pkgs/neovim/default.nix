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
      require("example")
    '';
  };

  tired = neovimBuilder {
    nvim-src = fileset.toSource {
      root = ../../../.;
      fileset = fileset.unions [
        ../../../lua/common
        ../../../lua/config
        ../../../lua/tired
      ];
    };

    lspPackages = with pkgs; rec {
      lua = [
        lua-language-server
        stylua
        selene
      ];

      nix = [
        nixd
        nixfmt-rfc-style
        deadnix
        statix
      ];

      rust = [
        rust-analyzer

        # Debugging
        lldb
      ] ++ toml;

      toml = [ taplo ];
    };

    plugins = with vimPlugins; [
      lazy-nvim
      lazyvim

      mini-ai
      mini-pairs
      trouble-nvim
      conform-nvim
      nvim-lint
      neodev-nvim
      neoconf-nvim

      nvim-cmp
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      nvim-snippets
      friendly-snippets

      nvim-lspconfig

      nvim-treesitter
      nvim-treesitter-textobjects
      ts-comments-nvim
      nvim-ts-autotag

      gitsigns-nvim
      todo-comments-nvim

      telescope-nvim
      telescope-fzf-native-nvim
      neo-tree-nvim

      lualine-nvim
      indent-blankline-nvim
      lsp-progress-nvim

      catppuccin-nvim
      which-key-nvim

      crates-nvim
      rustaceanvim

      # Dependencies
      nvim-web-devicons
      nui-nvim
      plenary-nvim
    ];
    luaRc = ''
      require("tired.config.lazy")
    '';
  };
in
tired.overrideAttrs (
  _: previousAttrs: {
    passthru = recursiveUpdate previousAttrs.passthru {
      inherit
        example
        noPlugins
        minimal
        tired
        ;
    };
  }
)
