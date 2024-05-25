{
  pkgs,
  lib,
  tree-sitter,
  runCommandNoCC,
  neovimUtils,
  vimPlugins,
  neovim-unwrapped,
  extraPlugins ? [ ],
  extraPackages ? [ ],
  treesitter-grammars ? vimPlugins.nvim-treesitter.allGrammars,
  extraName ? "my",
  version ? "unkown-dirty",
  ...
}:
let
  inherit (builtins) map;
  inherit (lib) fileset;
  inherit (lib.strings) getName concatStrings;

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

  plugins =
    (with vimPlugins; [
      lazy-nvim
      catppuccin-nvim
      nvim-treesitter
    ])
    ++ extraPlugins;

  extraPackages' = [ ] ++ extraPackages;

  neovimConfig = neovimUtils.makeNeovimConfig {
    withPython3 = true;
    withRuby = false;
    plugins = [ config ];
    # NOTE: can't use this method since I couldn't not find a way to get the
    # packdir path for `lucaRcContent`
    #
    # ++ (map (plugin: {
    #   inherit plugin;
    #   optional = true;
    # }) plugins);
  };

  mergedPlugins = runCommandNoCC "neovim-plugins" { } (
    ''
      mkdir -p $out/pack/myNeovimPackages/opt
    ''
    + (concatStrings (
      map (
        vimPlugin:
        let
          vimPluginName = getName vimPlugin;
        in
        ''
          cp -a ${vimPlugin} $out/pack/myNeovimPackages/opt/${vimPluginName}
        ''
      ) plugins
    ))
  );

  neovim-unwrapped' = neovim-unwrapped.overrideAttrs (
    _: previousAttrs: {
      treesitter-parsers = { };
      preConfigure =
        previousAttrs.preConfigure or ""
        + (
          let
            grammar = tree-sitter.withPlugins (_: treesitter-grammars);
          in
          ''
            mkdir -p $out/lib/nvim/parser/
            cp -a ${grammar}/*.so $out/lib/nvim/parser/
          ''
        );
    }
  );
in
pkgs.wrapNeovimUnstable neovim-unwrapped' (
  lib.recursiveUpdate neovimConfig {
    inherit extraName;
    wrapperArgs =
      lib.escapeShellArgs neovimConfig.wrapperArgs
      + " "
      + ''--suffix PATH : "${lib.makeBinPath extraPackages'}"'';

    luaRcContent =
      ''
        vim.g.is_nix = true
        vim.g.nix_plugins_path = "${mergedPlugins}"

        vim.opt.packpath:prepend("${mergedPlugins}")
      ''
      + builtins.readFile ../../../init.lua;
  }
)
