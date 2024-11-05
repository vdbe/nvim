local set = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Exit with jk
set({ "!", "t" }, "jk", [[<c-\><c-n>]], { desc = "Exit to normal mode" })

local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function() go { severity = severity, float = true } end
end

-- Copy/paste with system clipboard
set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
set('n', '<leader>p', '"+p', { desc = 'paste from system clipboard' })
-- - paste in visual with `p` to not copy selected text (`:h v_p`)
set('x', '<leader>p', '"+p', { desc = 'paste from system clipboard' })

-- Search inside visually highlighted text. Use `silent = false` for it to
-- make effect immediately.
set('x', 'g/', '<esc>/\\%V', { silent = false, desc = 'Search inside visual selection' })

set({ "n", "v", "x" }, "<leader>w", "<C-W>")

-- Reselect latest changed, put, or yanked text
set('n', 'gV', '"`[" . strpart(getregtype(), 0, 1) . "`]"',
  { expr = true, replace_keycodes = false, desc = 'Visually select changed text' })

-- Better j/k on wrapped lines
set({ "n", "v", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
set({ "n", "v", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

--- Jump to diagnostic
--- Already exists for ]d, ]i is already a keybind
set({ "n", "v", "x" }, "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
set({ "n", "v", "x" }, "[e", diagnostic_goto(true, "ERROR"), { desc = "Prev Error" })
set({ "n", "v", "x" }, "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warn" })
set({ "n", "v", "x" }, "[w", diagnostic_goto(true, "WARN"), { desc = "Prev Warn" })
set({ "n", "v", "x" }, "]h", diagnostic_goto(true, "HINT"), { desc = "Next Hint" })
set({ "n", "v", "x" }, "[h", diagnostic_goto(true, "HINT"), { desc = "Prev Hint" })
