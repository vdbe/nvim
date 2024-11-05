{
  version ? "unknown-dirty",
  pkgs,
  lib,
  callPackage,
  vimPlugins,
  ...
}:
let
  inherit (lib) fileset;
  inherit (lib.attrsets) recursiveUpdate;

  neovimBuilder = args: callPackage ./builder.nix ({ inherit version; } // args);

in
neovimBuilder {
  plugins = {
    start = with vimPlugins; [
      lz-n
    ];
    opt = with vimPlugins; [
      care-nvim
      fzy-lua-native
      nvim-treesitter
      catppuccin-nvim
      conform-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      plenary-nvim
      nvim-lint
      mini-nvim

      gitsigns-nvim

      nvim-lspconfig
      rustaceanvim
      crates-nvim
    ];
  };
}
# tired.overrideAttrs (
#   _: previousAttrs: {
#     passthru = recursiveUpdate previousAttrs.passthru {
#       inherit
#         example
#         noPlugins
#         minimal
#         tired
#         ;
#     };
#   }
# )
