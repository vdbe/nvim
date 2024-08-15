local Util = require "lazyvim.util"

---@class util.toggle
---@field package _virtual_text boolean|table
---@field package _virtual_lines boolean|OptsVirtualLines
local M = {}

M.current_line_enabled = false
M.virtual_lines_enabled = false

local function update_diagnostics()
  local diagnostic = vim.diagnostic.config()

  if M.virtual_lines_enabled then
    if diagnostic.virtual_text then M._virtual_text = diagnostic.virtual_text end
    diagnostic.virtual_text = false

    diagnostic.virtual_lines = M._virtual_lines or Util.opts("lsp_lines.nvim").virtual_lines
    diagnostic.virtual_lines.only_current_line = M.current_line_enabled
  elseif M.current_line_enabled then
    diagnostic.virtual_text = M._virtual_text

    diagnostic.virtual_lines = M._virtual_lines or Util.opts("lsp_lines.nvim").virtual_lines
    diagnostic.virtual_lines.only_current_line = true
  else
    diagnostic.virtual_text = M._virtual_text

    M._virtual_lines = diagnostic.virtual_lines
    diagnostic.virtual_lines = false
  end

  vim.diagnostic.config(diagnostic)
end

function M.diagnostic_lines()
  M.virtual_lines_enabled = not M.virtual_lines_enabled
  update_diagnostics()
end

function M.diagnostic_lines_only_current()
  M.current_line_enabled = not M.current_line_enabled
  update_diagnostics()
end

function M.diagnostic_lines_only_current()
  M.current_line_enabled = not M.current_line_enabled
  update_diagnostics()
end

return M
