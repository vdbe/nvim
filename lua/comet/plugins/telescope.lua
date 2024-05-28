return {
  { import = "astronvim.plugins.telescope" },
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        enabled = vim.g.is_nix or (vim.fn.executable "make" == 1),
      },
    },
    opts = function()
      local actions = require "telescope.actions"

      return {
        defaults = {
          mappings = {
            i = {
              ["jk"] = actions.close,
            },
            n = {
              ["q"] = actions.close,
            },
          },
        },
      }
    end,
  },
}
