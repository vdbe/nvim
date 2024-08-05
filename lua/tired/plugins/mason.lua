return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    enabled = not vim.g.is_nix,
  },

  vim.g.is_nix and {
    { "williamboman/mason.nvim", enabled = false },
    { "williamboman/mason-lspconfig.nvim", enabled = false },
    { "jay-babu/mason-nvim-dap.nvim", enabled = false },
    { "leoluz/nvim-dap-go", enabled = false },
  } or {},
}
