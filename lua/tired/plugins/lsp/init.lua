-- Don't ask
local lazyvim_lsp_plugin_spec = require "lazyvim.plugins.lsp"
local lspconfig_spec = table.remove(lazyvim_lsp_plugin_spec, 1)

return {
  -- Can't just import because of `lazyvim.plugins.lsp.keymaps`
  -- { require "lazyvim.plugins.lsp" },
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = lspconfig_spec.event,
    dependencies = lspconfig_spec.dependencies,
    -- Needed because you otherwise you can't overwrite opts for some reason )':
    ---@class PluginLspOpts
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      keys[#keys + 1] =
        { "<leader>a", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" }

      return lspconfig_spec.opts()
    end,
    config = lspconfig_spec.config,
  },
  lazyvim_lsp_plugin_spec,
}
