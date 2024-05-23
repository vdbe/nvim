{callPackage, ...}: self: super: {
  lazy-nvim = super.lazy-nvim.overrideAttrs (_: previousAttrs: {
    patches =
      previousAttrs.patches
      or []
      ++ [
        ./patches/lazy-nvim/no-helptags.patch
      ];
  });

  nvim-treesitter = super.nvim-treesitter.overrideAttrs (
    callPackage ./nvim-treesitter/overrides.nix {} self super
  );
}
