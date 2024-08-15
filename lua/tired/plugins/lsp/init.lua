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
    opts = lspconfig_spec.opts(),
    config = function(name, opts)
      LazyVim.lsp.on_attach(function(_, bufnr)
        vim.api.nvim_create_autocmd("InsertEnter", {
          buffer = bufnr,
          callback = function()
            if LazyVim.toggle.inlay_hints.get() then
              LazyVim.toggle.inlay_hints.set(false)
              vim.api.nvim_create_autocmd("InsertLeave", {
                buffer = bufnr,
                once = true,
                callback = function() LazyVim.toggle.inlay_hints.set(true) end,
              })
            end
          end,
        })
      end)

      lspconfig_spec.config(name, opts)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      keys[#keys + 1] =
        { "<leader>a", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" }

      -- return lspconfig_spec.opts()
    end,
  },
  -- Diagnostics in virtual lines
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    lazy = true,
    dependencies = {
      {
        "neovim/nvim-lspconfig",
        opts = {
          diagnostics = {
            ---@type boolean|OptsVirtualLines
            virtual_lines = false,
          },
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>L", function() require("tired.util.toggle").diagnostic_lines() end, desc = "Toggle Diagnostics Lines", },
      { "<leader>l", function() require("tired.util.toggle").diagnostic_lines_only_current() end, desc = "Toggle Diagnostics Current line", },
    },
    opts = {
      ---@type OptsVirtualLines
      virtual_lines = {
        only_current_line = false,
        highlight_whole_line = true,
      },
    },
    config = true,
  },
  lazyvim_lsp_plugin_spec,
}
