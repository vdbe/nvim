return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nixd = {
          settings = {
            nixd = {
              nixpkgs = {
                expr = "import <nixpkgs> { }",
              },
              formatting = {
                command = { "nixfmt" },
              },
            },
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "lua", "luap" })
    end,
  },
  -- NOTE: https://github.com/williamboman/mason-lspconfig.nvim/issues/390
  -- {
  --   "williamboman/mason-lspconfig.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "nixd" })
  --   end,
  -- },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed =
        -- NOTE: does not have statix, deadnix or nixmft
        require("astrocore").list_insert_unique(opts.ensure_installed, { "statix", "deadnix", "nixmft" })
    end,
  },
  -- Handled by nixd
  -- {
  --   "stevearc/conform.nvim",
  --   optional = true,
  --   opts = {
  --     formatters_by_ft = {
  --       nix = { "nixmft" },
  --     },
  --   },
  -- },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        nix = { "deadnix", "statix" },
      },
    },
  },
}
