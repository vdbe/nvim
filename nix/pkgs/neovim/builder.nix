{
  lib,

  neovimUtils,
  neovim-unwrapped,
  wrapNeovimUnstable,
  vimUtils,
  vimPlugins,

  pname ? "mynvim",
  version ? "unknown-dirty",
  baseConfig ? { },
  luaRcContent ? "require('vdbe')",
  plugins ? {
    opt = [ ];
    start = [ ];
  },
  config-src ? import ./config-src.nix { inherit lib; },
  tree-sitter,
  treesitter-grammars ? vimPlugins.nvim-treesitter.allGrammars,
  ...
}:
let
  normalizePlugin =
    optional: plugin:
    let
      defaultPlugin = {
        plugin = null;
        config = null;
        inherit optional;
      };
    in
    defaultPlugin // (if (plugin ? plugin) then plugin else { inherit plugin; });

  normalizedPlugins =
    let

      opt =
        let
          normalizePlugin' = normalizePlugin true;
        in
        map normalizePlugin' (plugins.opt or [ ]);
      start =
        let
          normalizePlugin' = normalizePlugin false;
        in
        map normalizePlugin' (plugins.start or [ ]);
    in
    opt ++ start;

  # User config
  neovimConfig = vimUtils.buildVimPlugin {
    inherit version;
    pname = "${pname}-config";
    src = config-src;
  };

  parsers = vimUtils.buildVimPlugin {
    inherit version;

    pname = "${pname}-parsers";

    src = tree-sitter.withPlugins (_: treesitter-grammars);
    path = "parser";
  };
  neovimConfigNormalized = normalizePlugin false neovimConfig;

  config = baseConfig // {
    # inherit luaRcContent;
    luaRcContent =
      ''
        vim.g.is_nix = true;
      ''
      + luaRcContent;
    plugins = normalizedPlugins ++ [
      neovimConfigNormalized
      parsers
    ];
  };
in
wrapNeovimUnstable neovim-unwrapped config
