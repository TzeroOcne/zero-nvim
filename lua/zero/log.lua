local M = {}

-- Change this to your preferred log file path
local log_file = vim.fn.stdpath('data') .. '/nryy.log'

---@class zero.log.Opts
---@field notify? boolean

---@param message any
---@param opts? zero.log.Opts
function M.log(message, opts)
  if vim.g.zerolog then
    if opts and opts.notify then
      vim.notify(message, vim.log.levels.INFO, { title = 'nryy.log' })
    end
    local log_entry = string.format('[%s] %s\n', os.date('%Y-%m-%d %H:%M:%S'), message)
    local file = io.open(log_file, 'a')
    if file then
      file:write(log_entry)
      file:close()
    else
      vim.notify('Failed to open log file: ' .. log_file, vim.log.levels.ERROR)
    end
  end
end

return M
