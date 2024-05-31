return {
  -- catppuccin
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      background = { -- :h background
        light = "latte",
        dark = "frappe",
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        headlines = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mason = not vim.g.is_nix,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
}
