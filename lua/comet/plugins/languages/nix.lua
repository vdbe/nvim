return {
  {
    "AstroNvim/astrolsp",
    optional = true,
    opts = {
      config = {
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
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "nix" })
      end
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
  -- {
  --   "WhoIsSethDaniel/mason-tool-installer.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts.ensure_installed =
  --       -- NOTE: does not have statix, deadnix or nixmft
  --       require("astrocore").list_insert_unique(opts.ensure_installed, { "statix", "deadnix", "nixmft" })
  --   end,
  -- },
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require "null-ls"
      if type(opts.sources) == "table" then
        vim.list_extend(opts.sources, {
          nls.builtins.code_actions.statix,
          nls.builtins.diagnostics.deadnix,
          -- nls.builtins.formatting.nixfmt, -- handled by nixd
        })
      end
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
        nix = { "statix" },
      },
    },
  },
}
