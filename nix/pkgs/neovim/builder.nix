{
  pkgs,
  lib,
  tree-sitter,
  vimUtils,
  neovimUtils,
  vimPlugins,
  neovim-unwrapped,
  withPython3 ? true,
  withNodeJs ? false,
  withRuby ? false,
  vimAlias ? false,
  viAlias ? false,
  nvim-src ? import ./nvim-src.nix { inherit lib; },
  treesitter-grammars ? vimPlugins.nvim-treesitter.allGrammars,
  extraName ? "my",
  version ? "unknown-dirty",
  plugins ? [ ],
  extraPackages ? [ ],
  lspPackages ? { },
  extraLspPackages ? { },
  luaRc ? builtins.readFile ../../../init.lua,
  # Extras
  extraPlugins ? [ ],
  extraExtraPackages ? [ ],
  ...
}:
let
  inherit (builtins)
    map
    mapAttrs
    attrNames
    attrValues
    listToAttrs
    ;
  inherit (lib.lists)
    optional
    optionals
    unique
    flatten
    ;
  inherit (lib.attrsets) recursiveUpdate;

  config = vimUtils.buildVimPlugin {
    inherit version;
    pname = "neovim-config-lua${extraName}";

    src = nvim-src;
  };

  parsers = vimUtils.buildVimPlugin {
    inherit version;

    pname = "parsers${extraName}";

    src = tree-sitter.withPlugins (_: treesitter-grammars);
    path = "parser";
  };

  plugins' = plugins ++ extraPlugins;
  packages' = extraPackages ++ extraExtraPackages;

  lspPackages' =
    let
      languages = unique ((attrNames lspPackages) ++ (attrNames extraLspPackages));
      mergeLanguage =
        language: unique ((lspPackages.${language} or [ ]) ++ (extraLspPackages.${language} or [ ]));
      combinedLspPackages = listToAttrs (
        map (language: {
          name = language;
          value = mergeLanguage language;
        }) languages
      );
      allLanguages = unique (flatten (attrValues combinedLspPackages));
    in
    combinedLspPackages // { inherit allLanguages; };

  neovimConfig = neovimUtils.makeNeovimConfig {
    inherit
      withPython3
      withNodeJs
      withRuby
      vimAlias
      viAlias
      ;
    plugins =
      [ config ]
      ++ optional (treesitter-grammars != [ ]) parsers
      ++ (map (plugin: {
        inherit plugin;
        optional = true;
      }) plugins');
  };

  # Extract packpathDirs so we can set the path in `vim.g`
  inherit (neovimConfig) packpathDirs;
  neovimConfig' = neovimConfig // {
    packpathDirs.myNeovimPackages = {
      start = [ ];
      opt = [ ];
    };
  };

  packpath = vimUtils.packDir packpathDirs;

  neovim-unwrapped' = neovim-unwrapped.overrideAttrs { treesitter-parsers = { }; };

  mkMynvim =
    packages'':
    pkgs.wrapNeovimUnstable neovim-unwrapped' (
      lib.recursiveUpdate neovimConfig' {
        inherit extraName;
        wrapperArgs = lib.escapeShellArgs (
          neovimConfig.wrapperArgs
          ++ (
            optionals (packpathDirs.myNeovimPackages.start != [ ] || packpathDirs.myNeovimPackages.opt != [ ]) [
              "--add-flags"
              ''--cmd "set packpath^=${packpath}"''
              "--add-flags"
              ''--cmd "set rtp^=${packpath}"''
            ]
            ++ optionals (packages'' != [ ]) [
              "--suffix"
              "PATH"
              ":"
              "${lib.makeBinPath (unique packages'')}"
            ]

          )
        );

        luaRcContent =
          ''
            vim.g.is_nix = true
            vim.g.nix_packpath = "${packpath}"
          ''
          + luaRc;
      }
    );

  # TODO: make it passthru recurisve somehow 
  # `.#default.withLsp.nix.lua`
  mynvim = mkMynvim packages';
  withLsp = (mkMynvim (packages' ++ lspPackages'.allLanguages)).overrideAttrs (
    _: previousAttrs: {
      passthru = recursiveUpdate previousAttrs.passthru (
        mapAttrs (_: value: mkMynvim (packages' ++ value)) lspPackages'
      );
    }
  );
in
mynvim.overrideAttrs (
  _: previousAttrs: { passthru = recursiveUpdate previousAttrs.passthru { inherit withLsp; }; }
)
