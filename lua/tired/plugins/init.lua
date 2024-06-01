require("lazyvim.config").init()

return {

  { "folke/lazy.nvim", version = "*" },
  {
    "LazyVim/LazyVim",
    priority = 10000,
    lazy = false,
    config = true,
    cond = true,
    version = "*",
    opts = {
      colorscheme = { "catppuccin" },
      defaults = {
        keymaps = false,
      },
      news = {
        lazyvim = false,
      },
      icons = {
        mics = {
          ActiveLSP = "",
        },
      },
    },
  },
}
