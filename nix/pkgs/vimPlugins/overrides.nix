{ callPackage, ... }:
self: super: {
  catppuccin-nvim = super.catppuccin-nvim.overrideAttrs (
    _: _: {
      # github:catppuccin/nvim recommends renaming plugin to catppuccin
      pname = "catppuccin";
    }
  );

  lazy-nvim = super.lazy-nvim.overrideAttrs (
    _: previousAttrs: {
      patches = previousAttrs.patches or [ ] ++ [ ./patches/lazy-nvim/no-helptags.patch ];
    }
  );

  nvim-treesitter = super.nvim-treesitter.overrideAttrs (
    callPackage ./nvim-treesitter/overrides.nix { } self super
  );
}
