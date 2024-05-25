{
  pkgs,
  lib,
  tree-sitter,
  runCommandNoCC,
  neovimUtils,
  vimPlugins,
  neovim-unwrapped,
  withPython3 ? true,
  withNodeJs ? false,
  withRuby ? false,

  nvim-src ? import ./nvim-src.nix { inherit lib; },
  treesitter-grammars ? vimPlugins.nvim-treesitter.allGrammars,
  extraName ? "my",
  version ? "unkown-dirty",
  plugins ? [ ],
  extraPackages ? [ ],
  luaRc ? builtins.readFile ../../../init.lua,

  # Extras
  extraPlugins ? [ ],
  extraExtraPackages ? [ ],
  ...
}:
let
  inherit (builtins) map length;
  inherit (lib.strings) getName concatStrings optionalString;

  config = pkgs.vimUtils.buildVimPlugin {
    inherit version;
    pname = "neovim-config-lua${extraName}";

    src = nvim-src;
  };

  plugins' = plugins ++ extraPlugins;

  packages' = extraPackages ++ extraExtraPackages;

  neovimConfig = neovimUtils.makeNeovimConfig {
    inherit withPython3 withNodeJs withRuby;
    plugins = [ config ];
    # NOTE: can't use this method since I couldn't not find a way to get the
    # packdir path for `lucaRcContent`
    #
    # ++ (map (plugin: {
    #   inherit plugin;
    #   optional = true;
    # }) plugins);
  };

  mergedPlugins = runCommandNoCC "neovim-plugins${extraName}" { } (
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
      ) plugins'
    ))
  );

  neovim-unwrapped' = neovim-unwrapped.overrideAttrs (
    _: previousAttrs: {
      treesitter-parsers = { };
      preConfigure =
        previousAttrs.preConfigure or ""
        + optionalString ((length treesitter-grammars) != 0) (
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
      + ''--suffix PATH : "${lib.makeBinPath packages'}"'';

    luaRcContent =
      ''
        vim.g.is_nix = true
      ''
      + optionalString ((length plugins') != 0) ''
        vim.g.nix_plugins_path = "${mergedPlugins}"

        vim.opt.packpath:prepend("${mergedPlugins}")
      ''
      + luaRc;
  }
)
