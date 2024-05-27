return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      install = not vim.g.is_nix,
      auto_install = not vim.g.is_nix,
    },
  },
  { import = "astronvim.plugins.treesitter" },
}
