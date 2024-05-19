local set = vim.keymap.set

vim.keymap.set({ "!", "t" }, "jk", [[<c-\><c-n>]], { desc = "Exit to normal mode" })
