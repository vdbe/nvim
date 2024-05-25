local set = vim.keymap.set
local Common = require("common")


Common.util.set_key_mappings(Common.keymaps)

-- Exit with jk
set({ "!", "t" }, "jk", [[<c-\><c-n>]], { desc = "Exit to normal mode" })
