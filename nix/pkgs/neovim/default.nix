{
  pkgs,
  lib,
  tree-sitter,
  stdenv,
  vimPlugins,
  neovim-unwrapped,
  extraPlugins ? [],
  extraPackages ? [],
  treesitter-grammars ? vimPlugins.nvim-treesitter.allGrammars,
  extraName ? "my",
  version ? "unkown-dirty",
  ...
}: let
  inherit (lib) fileset;

  config = pkgs.vimUtils.buildVimPlugin {
    inherit version;
    pname = "neovim-config-lua";

    src = fileset.toSource {
      root = ../../../.;
      fileset = fileset.unions [
        ../../../lua
        ../../../plugin
      ];
    };
  };

  plugins = with vimPlugins; [
    lazy-nvim
    catppuccin-nvim
    nvim-treesitter
  ];

  extraPackages' =
    [
    ]
    ++ extraPackages;

  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    withPython3 = true;
    withRuby = false;
    plugins = [
      (pkgs.symlinkJoin {
        name = "neovim-plugins";
        paths = [vimPlugins.nvim-treesitter.withAllGrammars] ++ plugins ++ [config] ++ extraPlugins;
      })
    ];
  };

  # FIX: DOn't rebuild everything for this
  neovim-unwrapped' = neovim-unwrapped.overrideAttrs (_: previousAttrs: {
    preConfigure =
      previousAttrs.preConfigure
      or ""
      + (let
        grammar = tree-sitter.withPlugins (_: treesitter-grammars);
      in ''
        mkdir -p $out/lib/nvim/parser/
        cp -a ${grammar}/*.so $out/lib/nvim/parser/
      '');
  });
in
  pkgs.wrapNeovimUnstable neovim-unwrapped' (lib.recursiveUpdate
    neovimConfig
    {
      inherit extraName;
      wrapperArgs =
        lib.escapeShellArgs neovimConfig.wrapperArgs
        + " "
        + ''--suffix PATH : "${lib.makeBinPath extraPackages'}"'';

      luaRcContent = ''
        vim.g.nix_plugins_path = '${config}'
        require("nobody")
      '';
    })
