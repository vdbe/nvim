local M = {}

local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function() go { severity = severity } end
end

M.n = {
  -- Window stuff
  ["<leader>wh"] = { "<C-W>h", desc = "Go to left window", remap = true },
  ["<leader>wj"] = { "<C-W>j", desc = "Go to lower window", remap = true },
  ["<leader>wk"] = { "<C-W>k", desc = "Go to upper window", remap = true },
  ["<leader>wl"] = { "<C-W>l", desc = "Go to right window", remap = true },
  ["<leader>wp"] = { "<C-W>p", desc = "Go to previous window", remap = true },
  ["<leader>wt"] = { "<C-W>t", desc = "Go to top left window", remap = true },
  ["<leader>wb"] = { "<C-W>b", desc = "Go to bottom right window", remap = true },
  ["<leader>ww"] = { "<C-W>w", remap = true },

  ["<leader>wH"] = { "<C-W>H", desc = "Move window left", remap = true },
  ["<leader>wJ"] = { "<C-W>J", desc = "Move window down", remap = true },
  ["<leader>wK"] = { "<C-W>K", desc = "Move window up", remap = true },
  ["<leader>wL"] = { "<C-W>L", desc = "Move window right", remap = true },

  ["<leader>ws"] = { "<C-W>s", desc = "Split Window below", remap = true },
  ["<leader>wv"] = { "<C-W>v", desc = "Split Window right", remap = true },

  ["<leader>y"] = { "+y", desc = "copy to clipboard" },

  j = { "v:count == 0 ? 'gj' : 'j'", expr = true, silent = true },
  k = { "v:count == 0 ? 'gk' : 'k'", expr = true, silent = true },

  ["<leader>cd"] = { vim.diagnostic.open_float, desc = "Line Diagnostics" },
  ["]e"] = { diagnostic_goto(true, "ERROR"), desc = "Next Error" },
  ["[e"] = { diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
  ["]w"] = { diagnostic_goto(true, "WARN"), desc = "Next Warning" },
  ["[w"] = { diagnostic_goto(false, "WARN"), desc = "Prev Warning" },

  ["<leader><tab>l"] = { "<cmd>tablast<cr>", desc = "Last Tab" },
  ["<leader><tab>f"] = { "<cmd>tabfirst<cr>", desc = "First Tab" },
  ["<leader><tab><tab>"] = { "<cmd>tabnew<cr>", desc = "New Tab" },
  ["<leader><tab>]"] = { "<cmd>tabnext<cr>", desc = "Next Tab" },
  ["<leader><tab>d"] = { "<cmd>tabclose<cr>", desc = "Close Tab" },
  ["<leader><tab>["] = { "<cmd>tabprevious<cr>", desc = "Previous Tab" },
}

M.v = {
  ["<leader>y"] = { "+y", desc = "copy to clipboard" },
}

M.x = {
  j = { "v:count == 0 ? 'gj' : 'j'", expr = true, silent = true },
  k = { "v:count == 0 ? 'gk' : 'k'", expr = true, silent = true },
}

return M
