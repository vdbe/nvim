vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("lazy").setup(
  { -- plugins
    import = "nobody.plugins",
  },
  { -- opts
    install = {
      missing = vim.g.is_nix == false,
    },
    change_detection = {
      notify = vim.g.is_nix == false,
    },
  }
)

