return {
  { import = "lazyvim.plugins.treesitter" },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    build = vim.g.is_nix and false,
    opts = {
      install = not vim.g.is_nix,
      auto_install = not vim.g.is_nix,
    },
  },
}
