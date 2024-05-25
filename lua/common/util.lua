local M = {}

--- Table based API for setting keybindings
---@param map_table AstroCoreMappings A nested table where the first key is the vim mode, the second key is the key to map, and the value is the function to set the mapping to
---@param base? vim.api.keyset.keymap A base set of options to set on every keybinding
function M.set_key_mappings(map_table, base)
  vim.print("test")

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

return M
