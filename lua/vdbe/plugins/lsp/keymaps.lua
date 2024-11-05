local M = {}

M.keymaps = {
  { "<leader>cl", "<cmd>LspInfo<cr>",          opts = { desc = "Lsp Info" } },
  { "gd",         vim.lsp.buf.definition,      opts = { desc = "Goto Definition" },          has = "definition" },
  { "gr",         vim.lsp.buf.references,      opts = { desc = "References", nowait = true } },
  { "gI",         vim.lsp.buf.implementation,  opts = { desc = "Goto Implementation" } },
  { "gy",         vim.lsp.buf.type_definition, opts = { desc = "Goto T[y]pe Definition" } },
  { "gD",         vim.lsp.buf.declaration,     opts = { desc = "Goto Declaration" } },
  { "K",          vim.lsp.buf.hover,           opts = { desc = "Hover" } },
  { "gK",         vim.lsp.buf.signature_help,  opts = { desc = "Signature Help" },           has = "signatureHelp" },
  { "<c-k>",      vim.lsp.buf.signature_help,  mode = "i",                                   opts = { desc = "Signature Help" }, has = "signatureHelp" },
  { "<leader>ca", vim.lsp.buf.code_action,     opts = { desc = "Code Action" },              mode = { "n", "v" },                has = "codeAction" },
  { "<leader>cc", vim.lsp.codelens.run,        opts = { desc = "Run Codelens" },             mode = { "n", "v" },                has = "codeLens" },
  {
    "<leader>cC",
    vim.lsp.codelens.refresh,
    opts = { desc = "Refresh & Display Codelens" },
    mode = { "n" },
    has = "codeLens",
  },
  { "<leader>cr", vim.lsp.buf.rename, opts = { desc = "Rename" }, has = "rename" },
}

---@param method string|string[]
---@param clients vim.lsp.Client[]
function M.has(buffer, method, clients)
  if type(method) == "table" then
    for _, m in ipairs(method) do
      if M.has(buffer, m) then return true end
    end
    return false
  end

  method = method:find "/" and method or "textDocument/" .. method
  local clients = vim.lsp.get_clients { bufnr = buffer }
  for _, client in ipairs(clients) do
    if client.supports_method(method) then return true end
  end
  return false
end

-- function M.resolve(buffer)
--   local Keys = require "lazy.core.handler.keys"
--   if not Keys.resolve then return {} end
--   local spec = M.get()
--   local opts = LazyVim.opts "nvim-lspconfig"
--   local clients = LazyVim.lsp.get_clients { bufnr = buffer }
--   for _, client in ipairs(clients) do
--     local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
--     vim.list_extend(spec, maps)
--   end
--   return Keys.resolve(spec)
-- end

function M.on_attach(buffer)
  -- local Keys = require "lazy.core.handler.keys"
  -- local keymaps = M.resolve(buffer)

  local clients = vim.lsp.get_clients { bufnr = buffer }

  for _, keymap in pairs(M.keymaps) do
    local has = not keymap.has or M.has(buffer, keymap.has, clients)
    local cond = not (keymap.cond == false or ((type(keymap.cond) == "function") and not keymap.cond()))

    if has and cond then
      local opts = vim.tbl_extend("force", {
        cond = nil,
        has = nil,
        silent = false,
        buffer = buffer,
      }, keymap.opts)
      vim.keymap.set(keymap.mode or "n", keymap[1], keymap[2], opts)
    end
  end
end

return M
