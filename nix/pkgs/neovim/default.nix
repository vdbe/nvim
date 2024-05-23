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
  inherit (lib.strings) getName optionalString;
  inherit (lib.lists) findFirst filter;

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
  ] ++ extraPlugins;

  lazyNvim = findFirst (plugin: (getName plugin) == "lazy-nvim") null plugins;
  filteredPlugins = if lazyNvim == null then
  plugins
  else
    filter (plugin: (getName plugin) != "lazy-nvim") plugins;

  extraPackages' =
    [
    ]
    ++ extraPackages;

  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    withPython3 = true;
    withRuby = false;
    plugins = [config];
    # plugins = [
    #   (pkgs.symlinkJoin {
    #     name = "neovim-plugins";
    #     paths = plugins ++ [config] ++ extraPlugins;
    #   })
    # ];
  };

  plugins' = pkgs.symlinkJoin {
    name = "neovim-plugins";
    paths = filteredPlugins;
  };


  neovim-unwrapped' = neovim-unwrapped.overrideAttrs (_: previousAttrs: {
    treesitter-parsers = {};
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

      luaRcContent = optionalString (lazyNvim != null) ''
        vim.opt.rtp:prepend("${lazyNvim}");
      '' + ''
        vim.g.is_nix = true
        vim.g.nix_plugins_path = "${plugins'}"

        require("nobody");
      '';
    })
