vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

require("lazy").setup(
  { -- plugins
    import = "nobody.plugins",
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
