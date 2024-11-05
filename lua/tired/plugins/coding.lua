local Util = require "tired.util"
return {
  { import = "lazyvim.plugins.coding" },
  {
    "hrsh7th/cmp-cmdline", -- cmdline completions
    event = "CmdlineEnter",
    version = false, -- last release is way too old
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local cmp = require "cmp"
      cmp.setup.cmdline({ "/", "?" }, {
        completion = {
          completeopt = "menu,menuone,noinsert,noselect",
        },
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer", option = { get_bufnrs = Util.visible_buffers } },
        },
      })

      cmp.setup.cmdline(":", {
        -- completion = {
        --   completeopt = "menu,menuone,noinsert,noselect",
        -- },
        mapping = cmp.mapping.preset.cmdline {
          ["<C-n>"] = { c = cmp.mapping.select_next_item() },
          ["<C-p>"] = { c = cmp.mapping.select_prev_item() },
        },
        sources = cmp.config.sources({
          { name = "buffer", option = { get_bufnrs = Util.visible_buffers } },
          { name = "path" },
        }, {
          { name = "cmdline" },
        }, {
          -- { name = "buffer", option = { get_bufnrs = Util.visible_buffers } },
        }),
      })
    end,
  },
}
