local M = {}
local Snacks = require('snacks')

local terminals = {}

function M.get_terminal_windows()
  ---@type integer[]
  local terminal_windows = {}

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf })
    if buftype == 'terminal' then
      table.insert(terminal_windows, win)
    end
  end

  return terminal_windows
end

function M.close_open_terminal_buffer()
  local window_list = M.get_terminal_windows()
  if #window_list > 0 then
    for _, win in ipairs(window_list) do
      vim.api.nvim_win_close(win, true)
    end
    return true
  end
  return false
end

-- Opens a floating terminal (interactive by default)
---@param cmd? string | string[]
---@param opts? snacks.terminal.Opts| {create?: boolean}
function M.terminal(cmd, opts)
  opts = opts or {}
  local id = vim.inspect({ cmd = cmd, cwd = opts.cwd, env = opts.env, count = vim.v.count1 })
  local terminal = Snacks.terminal(cmd, opts)
  terminals[id] = terminal
  return terminal
end

---@return string[]
function M.get_terminal_list()
  return vim.tbl_map(
    ---@param value string
    function(value)
      return load('return ' .. value)().cmd
    end,
    vim.tbl_keys(terminals)
  )
end

function M.select_terminal()
  return vim.ui.select(
    M.get_terminal_list(),
    {},
    function(choice)
      if choice then
        M.terminal(choice)
      end
    end
  )
end

return M