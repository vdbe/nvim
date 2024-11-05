-- local labels = { "a", "s", "d", "f", "q", "w", "e", "r", "1", "2", "3", "4" }
local labels = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }
local care = require "care"

care.setup {
  ui = {
    menu = {
      format_entry = function(entry, data)
        local components = require "care.presets.components"

        return {
          components.ShortcutLabel(labels, entry, data),
          components.Label(entry, data, true),
          components.KindIcon(entry, "fg"),
        }
      end,
    },
  },
  -- sources = {
  --   lsp = {
  --     filter = function(entry)
  --
  --       return entry.completion_item.kind ~= 1
  --     end
  --
  --   },
  -- },
  -- keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
  -- completion_events = { "TextChangedI" },
}

local next = function(direction, key)
  return function()
    if care.api.is_open() then
      care.api.select_next(direction)
      -- Pre PR
      -- if direction >= 0 then
      --   care.api.select_next(direction)
      -- else
      --   care.api.select_prev(-direction)
      -- end
    elseif vim.snippet.active { direction = direction } then
      vim.snippet.jump(direction)
    elseif key ~= nil then
      vim.api.nvim_feedkeys(vim.keycode(key), "n", false)
    else
      care.api.complete()
    end
  end
end

vim.keymap.set("i", "<c-n>", next(1))
vim.keymap.set("i", "<c-p>", next(-1))
vim.keymap.set("i", "<c-space>", function() require("care").api.complete() end)
vim.keymap.set("i", "<cr>", "<Plug>(CareConfirm)")
vim.keymap.set("i", "<c-e>", "<Plug>(CareClose)")
-- vim.keymap.set("i", "<tab>", next(1, "<tab>"))
-- vim.keymap.set("i", "<s-tab>", next(-1, "<s-tab>"))
vim.keymap.set("i", "<tab>", "<Plug>(CareSelectNext)")
vim.keymap.set("i", "<s-tab>", "<Plug>(CareSelectPrev)")

vim.keymap.set("i", "<c-f>", function()
  if require("care").api.doc_is_open() then
    require("care").api.scroll_docs(4)
  else
    vim.api.nvim_feedkeys(vim.keycode "<c-f>", "n", false)
  end
end)

vim.keymap.set("i", "<c-d>", function()
  if require("care").api.doc_is_open() then
    require("care").api.scroll_docs(-4)
  else
    vim.api.nvim_feedkeys(vim.keycode "<c-d>", "n", false)
  end
end)

for i, label in ipairs(labels) do
  local lhs = "<c-" .. label .. ">"
  vim.keymap.set("i", lhs, function()
    if care.api.is_open() then
      require("care").api.select_visible(i)
      -- If you also want to confirm the entry
      require("care").api.confirm()
    else
      vim.api.nvim_feedkeys(vim.keycode(lhs), "n", false)
    end
  end)
end
