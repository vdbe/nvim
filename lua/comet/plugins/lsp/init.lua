return {
  { import = "astronvim.plugins.lspconfig" },
  { import = "astronvim.plugins.lspkind" },
  { import = "astronvim.plugins.cmp_luasnip" },
  { import = "astronvim.plugins.mason" },
  { import = "astrocommunity.utility.mason-tool-installer-nvim" },
  vim.g.is_nix and {
    "AstroNvim/astrolsp",
    optional = true,
    config = function(_, opts)
      for key, _ in pairs(opts.config) do
        table.insert(opts.servers, key)
      end
      require("astrolsp").setup(opts)
    end,
  } or {},
  {
    "neovim/nvim-lspconfig",
    optional = true,
    config = function()
      -- set up servers configured with AstroLSP
      vim.tbl_map(require("astrolsp").lsp_setup, require("astrolsp").config.servers)
    end,
  },
  vim.g.is_nix and {
    "nvimtools/none-ls.nvim",
    dependencies = {
      { "AstroNvim/astrolsp", opts = {} },
    },
    opts = function() return { on_attach = require("astrolsp").on_attach } end,
  } or {},
}
