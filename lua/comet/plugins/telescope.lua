return {
  { import = "astronvim.plugins.telescope" },
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
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
