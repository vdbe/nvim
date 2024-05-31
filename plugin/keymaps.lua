if vim.g.no_plugin ~= false then
  local set = vim.keymap.set
  local Common = require "common"

  vim.g.mapleader = " "
  vim.g.maplocalleader = ","

  Common.util.set_key_mappings(Common.keymaps)

  -- Exit with jk
  set({ "!", "t" }, "jk", [[<c-\><c-n>]], { desc = "Exit to normal mode" })
end
