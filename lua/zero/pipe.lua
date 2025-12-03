local pipekiller = require("pipekiller")

local M = {}

---@param name string
function M.get_pipe_pid(name)
  return pipekiller.get_pipe_pid(name)
end

---@param pid integer
function M.kill_pid(pid)
  return pipekiller.kill_pid(pid)
end

---@param name string
function M.kill_pipe(name)
  local pid = M.get_pipe_pid(name)
  if pid then
    return M.kill_pid(pid)
  end
end

---@param name string
---@param timeout integer? milliseconds (default 5000)
---@param interval integer? milliseconds (default 100)
function M.wait_until_pipe_free(name, timeout, interval)
  timeout = timeout or 5000
  interval = interval or 100
  local elapsed = 0

  while elapsed < timeout do
    local pid = M.get_pipe_pid(name)

    if not pid then
      return true -- pipe is free
    end

    -- let Neovim event loop breathe
    vim.wait(interval)
    elapsed = elapsed + interval
  end

  return false -- timeout
end

---@param name string
---@param timeout integer? milliseconds
function M.kill_and_wait(name, timeout)
  -- kill owner if exists
  M.kill_pipe(name)

  -- wait for the pipe to be released
  local ok = M.wait_until_pipe_free(name, timeout)

  if not ok then
    vim.notify("Timeout waiting for pipe to free: " .. name, vim.log.levels.ERROR)
  end

  return ok
end

return M

