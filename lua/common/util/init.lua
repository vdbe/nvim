local M = {}

setmetatable(M, {
  __index = function(t, k)
    ---@diagnostic disable-next-line: no-unknown
    t[k] = require("common.util." .. k)
    return t[k]
  end,
})

--- Table based API for setting keybindings
---@param map_table AstroCoreMappings A nested table where the first key is the vim mode, the second key is the key to map, and the value is the function to set the mapping to
---@param base? vim.api.keyset.keymap A base set of options to set on every keybinding
function M.set_key_mappings(map_table, base)
  -- iterate over the first keys for each mode
  for mode, maps in pairs(map_table) do
    -- iterate over each keybinding set in the current mode
    for keymap, options in pairs(maps) do
      -- build the options for the command accordingly
      if options then
        local cmd
        local keymap_opts = base or {}
        if type(options) == "string" or type(options) == "function" then
          cmd = options
        else
          cmd = options[1]
          keymap_opts = vim.tbl_deep_extend("force", keymap_opts, options)
          keymap_opts[1] = nil
        end

        if cmd then -- set keymap
          vim.keymap.set(mode, keymap, cmd, keymap_opts)
        end
      end
    end
  end
end

--- Table based API for settings options
--@param option_table table<string,table<string,any>>?
function M.set_options(options)
  for scope, settings in pairs(options) do
    for setting, value in pairs(settings) do
      vim[scope][setting] = value
    end
  end
end

---@param name string
---@return string
function M.normname(name)
  local ret = name:lower():gsub("^n?vim%-", ""):gsub("%.n?vim$", ""):gsub("%.lua", ""):gsub("[^a-z]+", "")
  return ret
end

---@return string
function M.norm(path)
  if path:sub(1, 1) == "~" then
    local home = vim.uv.os_homedir()
    if home:sub(-1) == "\\" or home:sub(-1) == "/" then home = home:sub(1, -2) end
    path = home .. path:sub(2)
  end
  path = path:gsub("\\", "/"):gsub("/+", "/")
  return path:sub(-1) == "/" and path:sub(1, -2) or path
end

return M
