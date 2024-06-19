function main()
  local ok, lazy = pcall(require, "lazy")

  -- Only check for missing plugins when using `lazy.nvim`
  if not ok then return end

  local not_intstalled_title = "Not Installed"

  local Sections = require "lazy.view.sections"

  local filtered_tbl = vim.tbl_filter(function(section) return (section.title == not_intstalled_title) end, Sections)

  if vim.tbl_count(filtered_tbl) ~= 1 then
    vim.print("ERROR: Could't find section '" .. not_intstalled_title .. "'")
    return
  end

  local plugins = lazy.plugins()

  local filter_plugin_not_installed = vim.tbl_get(filtered_tbl, 1).filter
  local missing_plugins = vim.tbl_filter(function(plugin) return filter_plugin_not_installed(plugin) end, plugins)

  if vim.tbl_count(missing_plugins) == 0 then return end

  local errors = { "Missing plugins:" }
  for _, value in ipairs(missing_plugins) do
    local plugin_name = value.name
    local plugin_url = value.url

    local error_msg = "    - " .. plugin_name .. ": " .. plugin_url
    table.insert(errors, error_msg)
  end

  vim.print(table.concat(errors, "\n"))
end

main()
