local gr = vim.api.nvim_create_augroup('plugin_basic', {})

local au = function(event, pattern, callback, desc)
  vim.api.nvim_create_autocmd(event, { group = gr, pattern = pattern, callback = callback, desc = desc })
end

-- Check if we need to reload the file when it changed
au({ "FocusGained", "TermClose", "TermLeave" }, nil,
  function()
    if vim.o.buftype ~= "nofile" then vim.cmd "checktime" end
  end, "Reload buffer when needed"
)

-- Highlight on yank
au('TextYankPost', '*', function() vim.highlight.on_yank() end, 'Highlight yanked text')

-- Resize splits if window got resized
au("VimResized", nil,
  function()
    local current_tab = vim.fn.tabpagenr()

    vim.cmd "tabdo wincmd ="
    vim.cmd("tabnext " .. current_tab)
  end, 'Resize splits'
)


-- Go to last loc when opening a buffer
au('BufReadPost', nil, function(event)
  local exclude = { "gitcommit" }
  local buf = event.buf
  if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].mynvim_last_loc then return end
  vim.b[buf].mynvim_last_loc = true
  local mark = vim.api.nvim_buf_get_mark(buf, '"')
  local lcount = vim.api.nvim_buf_line_count(buf)
  if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
end, 'Enter buffer at last location'
)

-- make it easier to close man-files when opened inline
-- vim.api.nvim_create_autocmd("FileType", {
--   group = augroup "man_unlisted",
--   pattern = { "man" },
--   callback = function(event) vim.bo[event.buf].buflisted = false end,
-- })
--
-- wrap and check for spell in text filetypes

au("FileType", { "gitcommit", "markdown" }, function()
  vim.opt_local.wrap = true
  vim.opt_local.spell = true
end, 'Set wrap/spell for text filetypes')

local start_terminal_insert = vim.schedule_wrap(function(data)
  -- Try to start terminal mode only if target terminal is current
  if not (vim.api.nvim_get_current_buf() == data.buf and vim.bo.buftype == 'terminal') then return end
  vim.cmd('startinsert')
end)
au('TermOpen', 'term://*', start_terminal_insert, 'Start builtin terminal in Insert mode')
