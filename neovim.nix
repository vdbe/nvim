self: {
  lib,
  pkgs,
  ...
}: let
  inherit (lib) fileset;

  config = pkgs.vimUtils.buildVimPlugin {
    pname = "neovim-config-lua";
    version = self.shortRev or self.dirtyShortRev or "unknown-dirty";

    src = fileset.toSource {
      root = ./.;
      fileset = fileset.unions [
        ./lua
        ./plugin
      ];
    };
  };


  plugins = with pkgs.vimPlugins; [
    (lazy-nvim.overrideAttrs (_: previousAttrs: {
      patches = previousAttrs.patches ++ [./patches/lazy.nvim.patch];
    }))
    catppuccin-nvim
  ];

  extraPackages = [];

  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    withPython3 = true;
    withRuby = false;
    plugins = [(pkgs.symlinkJoin {
          name = "neovim-plugins";
          paths = plugins ++ [config];
      })];
    customRC = ''
      let g:nix_plugins_path = '${config}'
      lua require("nobody")
    '';
  };
in
  pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped neovimConfig
