return vim.g.is_nix
    and {
      {
        "williamboman/mason.nvim",
        enabled = false,
      },
      {
        "williamboman/mason-lspconfig.nvim",
        enabled = false,
      },
      {
        "jay-babu/mason-null-ls.nvim",
        enabled = false,
      },
      {
        "jay-babu/mason-nvim-dap.nvim",
        enabled = false,
      },
    }
  or {}
