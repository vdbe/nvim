return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    dir = vim.g.nix_plugins_path,
    lazy = false,
    priority = 1000,
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end
  },
}
