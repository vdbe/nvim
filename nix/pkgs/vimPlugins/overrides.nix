{ callPackage, ... }:
self: super: {
  # AstroNvim = super.AstroNvim.overrideAttrs {
  #   # dependencies = with self; [ astrocore ];
  #   # src = ../../../AstroNvim;
  # };

  catppuccin-nvim = super.catppuccin-nvim.overrideAttrs {
    # github:catppuccin/nvim recommends renaming plugin to catppuccin
    pname = "catppuccin";
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

  nvim-treesitter = super.nvim-treesitter.overrideAttrs (
    callPackage ./nvim-treesitter/overrides.nix { } self super
  );
}
