---@class util
---@field toggle util.toggle
local M = {}

setmetatable(M, {
  __index = function(t, k)
    ---@diagnostic disable-next-line: no-unknown
    t[k] = require("tired.util." .. k)
    return t[k]
  end,
})

return M
