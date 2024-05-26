return {
  { import = "astronvim.plugins.treesitter" },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      auto_install = vim.g.is_nix,
    },
  },
}
