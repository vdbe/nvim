return {
  {
    "williamboman/mason-lspconfig.nvim",
    enabled = not vim.g.is_nix,
  },
}
