vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

require("lazy").setup(
  { -- plugins
    {
      "catppuccin/nvim",
      name = "catppuccin",
      lazy = false,
      priority = 1000,
      config = function(_, opts)
        require("catppuccin").setup(opts)
        vim.cmd.colorscheme("catppuccin")
      end
    },
  },
  { -- opts
    defaults = {
      pin = vim.g.nix_plugins_path ~= nil,
    },
    install = {
      missing = vim.g.nix_plugins_path == nil,
    },
    change_detection = {
      notify = false,
    },
    performance = {
      rtp = {
        paths = {
          -- vim.g.nix_plugins_path -- Not needed when merging plugins with `symLinkJoin`
        },
      },
    },
  }
)
