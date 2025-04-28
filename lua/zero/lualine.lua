-- https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/util/lualine.lua#L27
local M = {}

---@module "snacks"

---@param icon string
---@param status fun(): nil|"ok"|"error"|"pending"
function M.status(icon, status)
  local colors = {
    ok = "Special",
    error = "DiagnosticError",
    pending = "DiagnosticWarn",
  }
  return {
    function()
      return icon
    end,
    cond = function()
      return status() ~= nil
    end,
    color = function()
      return { fg = Snacks.util.color(colors[status()] or colors.ok) }
    end,
  }
end

---@param name string
---@param icon? string
function M.cmp_source(name, icon)
  icon = icon or require('zero.config').icons.kinds[name:sub(1, 1):upper() .. name:sub(2)]
  local started = false
  return M.status(icon, function()
    if not package.loaded["cmp"] then
      return
    end
    for _, s in ipairs(require("cmp").core.sources or {}) do
      if s.name == name then
        if s.source:is_available() then
          started = true
        else
          return started and "error" or nil
        end
        if s.status == s.SourceStatus.FETCHING then
          return "pending"
        end
        return "ok"
      end
    end
  end)
end

return M
