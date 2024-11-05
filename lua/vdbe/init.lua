-- Needs to be set before loading lz.n
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.is_nix = vim.g.is_nix == true

require "vdbe.options"

vim.api.nvim_create_autocmd("User", {
  callback = function() require("vdbe.util.root").setup() end,
  once = true,
})

require("lz.n").load {
  require "vdbe.plugins.treesitter",
  require "vdbe.plugins.telescope",
  require "vdbe.plugins.rust",
  {
    "nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    after = function() require "vdbe.plugins.lsp.after" end,
  },
  {
    "care.nvim",
    event = { "InsertEnter" },
    before = function() require("lz.n").trigger_load { "fzy-lua-native" } end,
    after = function() require "vdbe.plugins.care.after" end,
  },
  {
    "mini.nvim",
    -- event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    event = { "DeferredUIEnter" },
    after = function() require "vdbe.plugins.mini.after" end,
  },
  {
    "gitsigns.nvim",
    event = { "DeferredUIEnter" },
    -- event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    after = function() require "vdbe.plugins.gitsigns.after" end
  },
  {
    "catppuccin",
    priority = 1000,
    after = function()
      require("catppuccin").setup {
        flavour = "auto",
        background = {
          light = "latte",
          dark = "mocha",
        },
        term_colors = true,
        default_integrations = false,
        integrations = {
          treesitter = true,
          semantic_tokens = true,
          telescope = {
            enabled = true,
          },
          gitsigns = true,
          mini = {
            enabled = true,
          },
        },
      }

      vim.cmd.colorscheme "catppuccin"

      -- Trigger early redraw
      -- vim.cmd([[redraw]])
    end,
  },
  {
    "nvim-lint",
    -- event = { "BufRead", "BufNewFile", "BufWritePre" },
    event = { "DeferredUIEnter" },
    after = function()
      local lint = require "lint"

      lint.linters_by_ft = {
        lua = { "selene" },
        nix = { "deadnix", "statix" },
      }

      vim.api.nvim_create_autocmd({
        "BufEnter",
        "BufReadPost",
        "InsertLeave",
        -- "TextChanged"
      }, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = function()
          -- try_lint without arguments runs the linters defined in `linters_by_ft`
          -- for the current filetype
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<space>cf",
        function() require("conform").format() end,
        mode = { "n", "v", "x" },
        desc = "Format buffer",
      },
    },
    after = function()
      require("conform").setup {
        default_format_opts = {
          lsp_format = "fallback",
          async = true,
          timeout_ms = 500,
          range = false,
        },
        format_on_save = {},
      }
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  {
    -- Required by telescope
    "plenary.nvim",
    lazy = true,
  },
  {
    -- Required by care.nvim
    "fzy-lua-native",
    lazy = true,
  },
}
