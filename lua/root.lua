local M = setmetatable({}, {
  __call = function(m, ...)
    return m.get(...)
  end,
})

function M.get()
  local rooter = require("astrocore.rooter")
  local roots = rooter.detect()
  return roots[1] and roots[1].paths[1] or vim.uv.cwd()
end

return M
