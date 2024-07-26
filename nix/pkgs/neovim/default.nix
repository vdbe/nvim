{
  version ? "unknown-dirty",
  pkgs,
  lib,
  callPackage,
  vimPlugins,
  ...
}:
let
  inherit (lib) fileset;
  inherit (lib.attrsets) recursiveUpdate;

  neovimBuilder = args: callPackage ./builder.nix ({ inherit version; } // args);

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
      bash = [
        nodePackages.bash-language-server

        shellcheck
        shfmt
      ];

      lua = [
        lua-language-server

        selene
        stylua
      ];

      nix = [
        nixd

        deadnix
        nixfmt-rfc-style
        statix
      ];

      python = [
        pyright
        ruff
      ];

      rust = [
        rust-analyzer

        # Debugging
        lldb
      ] ++ toml;

      toml = [ taplo ];

      yaml = [ yaml-language-server ];

      json = [ vscode-langservers-extracted ];
    };

    plugins = with vimPlugins; [
      lazy-nvim
      lazyvim

      mini-ai
      mini-pairs
      trouble-nvim
      conform-nvim
      nvim-lint
      luvit-meta
      lazydev-nvim

      nvim-cmp
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      nvim-snippets
      friendly-snippets

      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
      nvim-nio

      nvim-dap-python

      nvim-lspconfig

      nvim-treesitter
      nvim-treesitter-textobjects
      ts-comments-nvim
      nvim-ts-autotag
      schemastore-nvim
      venv-selector-nvim

      gitsigns-nvim
      todo-comments-nvim
      grug-far-nvim
      vimtex

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
      dressing-nvim
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
