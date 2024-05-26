return {
  { import = "astrocommunity.pack.lua" },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    dependencies = {
      { 
        "AstroNvim/astrolsp",
        opts = {
          servers = { "lua_ls"},
        } ,
      },
    },
    config = function()
      -- set up servers configured with AstroLSP
      vim.tbl_map(require("astrolsp").lsp_setup, require("astrolsp").config.servers)
    end,
  },
}
