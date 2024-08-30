return {
  {
    "mrcjkb/rustaceanvim",
    optional = true,
    opts = {
      server = {
        default_settings = {
          -- rust-analyzer language server configuration
          diagnostics = {
            enable = true,
            disabled = {},
            enableExperimental = true,
          },
        },
      },
    },
  },

  { import = "lazyvim.plugins.extras.lang.rust" },
}
