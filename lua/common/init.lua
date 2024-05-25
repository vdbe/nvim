local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("common." .. k)
    return t[k]
  end,
})

return M
