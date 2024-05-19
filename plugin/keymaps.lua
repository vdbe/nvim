local set = vim.keymap.set

-- Exit with jk
set({ "!", "t" }, "jk", [[<c-\><c-n>]], { desc = "Exit to normal mode" })

-- Copy to system clipboard
set({ "v", "n" }, "<leader>y", '"+y', { desc = "copy to clipboard" })

-- Window stuff
set({ "n" }, "<leader>wh", "<C-W>h", { desc = "Go to left window", remap = true })
set({ "n" }, "<leader>wj", "<C-W>j", { desc = "Go to lower window", remap = true })
set({ "n" }, "<leader>wk", "<C-W>k", { desc = "Go to upper window", remap = true })
set({ "n" }, "<leader>wl", "<C-W>l", { desc = "Go to right window", remap = true })
set({ "n" }, "<leader>wp", "<C-W>p", { desc = "Go to previous window", remap = true })
set({ "n" }, "<leader>wt", "<C-W>t", { desc = "Go to top left window", remap = true })
set({ "n" }, "<leader>wb", "<C-W>b", { desc = "Go to bottom right window", remap = true })
set({ "n" }, "<leader>ww", "<C-W>w", { remap = true })

set({ "n" }, "<leader>wH", "<C-W>H", { desc = "Move window left", remap = true })
set({ "n" }, "<leader>wJ", "<C-W>J", { desc = "Move window down", remap = true })
set({ "n" }, "<leader>wK", "<C-W>K", { desc = "Move window up", remap = true })
set({ "n" }, "<leader>wL", "<C-W>L", { desc = "Move window right", remap = true })

set({ "n" }, "<leader>ws", "<C-W>s", { desc = "Split Window below", remap = true })
set({ "n" }, "<leader>wv", "<C-W>v", { desc = "Split Window right", remap = true })

-- Resize window using <ctrl> arrow keys
set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })


-- Better up/down
set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- tabs
set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
set("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
