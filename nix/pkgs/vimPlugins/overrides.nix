{ lib, callPackage, ... }:
self: super: {
  AstroNvim = super.AstroNvim.overrideAttrs { dependencies = with self; [ astrocore ]; };

  catppuccin-nvim = super.catppuccin-nvim.overrideAttrs {
    # github:catppuccin/nvim recommends renaming plugin to catppuccin
    pname = "catppuccin";
  };

  telescope-fzf-native-nvim = super.telescope-fzf-native-nvim.overrideAttrs {
    dependencies = with self; [ telescope-nvim ];
    buildPhase = "make";
    meta.platforms = lib.platforms.all;
  };

  lazy-nvim = super.lazy-nvim.overrideAttrs (
    _: previousAttrs: {
      patches = previousAttrs.patches or [ ] ++ [
        ./patches/lazy-nvim/no-helptags.patch

        ./patches/lazy-nvim/allow-symlinked-plugins.patch
        ./patches/lazy-nvim/add-nix-packpath.patch
      ];
    }
  );

  lazyvim = super.lazyvim.overrideAttrs (
    _: previousAttrs: {
      patches = previousAttrs.patches or [ ] ++ [ ./patches/lazyvim/nvim-dap-python.patch ];
    }
  );

  none-ls-nvim = super.none-ls-nvim.overrideAttrs { dependencies = with self; [ plenary-nvim ]; };

  nvim-treesitter = super.nvim-treesitter.overrideAttrs (
    callPackage ./nvim-treesitter/overrides.nix { } self super
  );
}
