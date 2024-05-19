{
  self ? null,
  pkgs,
  lib ? pkgs.lib,
  vimPlugins ? pkgs.vimPlugins,
  neovim-unwrapped ? pkgs.neovim-unwrapped,
  extraPlugins ? [],
  extraPackages ? [],
  ...
}: let
  inherit (lib) fileset;

  config = pkgs.vimUtils.buildVimPlugin {
    pname = "neovim-config-lua";
    version = self.shortRev or self.dirtyShortRev or "unknown-dirty";

    src = fileset.toSource {
      root = ../.;
      fileset = fileset.unions [
        ../lua
        ../plugin
      ];
    };
  };

  plugins = with vimPlugins; [
    (lazy-nvim.overrideAttrs (_: previousAttrs: {
      patches = previousAttrs.patches or [] ++ [./patches/lazy.nvim.patch];
    }))
    catppuccin-nvim
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
        paths = plugins ++ [config] ++ extraPlugins;
      })
    ];
  };
in
  pkgs.wrapNeovimUnstable neovim-unwrapped (lib.recursiveUpdate
    neovimConfig
    {
      extraName = "-my";
      wrapperArgs =
        lib.escapeShellArgs neovimConfig.wrapperArgs
        + " "
        + ''--suffix PATH : "${lib.makeBinPath extraPackages'}"'';

      luaRcContent = ''
        vim.g.nix_plugins_path = '${config}'
        require("nobody")
      '';
    })
