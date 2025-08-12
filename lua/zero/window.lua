local M = {}

---Get the buffer type of a given window.
---@param win integer Window handle.
---@return string buftype The buffer type of the window.
---Possible values:
---  - '' (empty string): Normal file buffer
---  - 'help', 'quickfix', 'nofile', etc. (see `:h buftype`)
function M.get_win_buftype(win)
  local buf = vim.api.nvim_win_get_buf(win)
  return vim.api.nvim_get_option_value('buftype', { buf = buf })
end

---Check if a window is a normal file buffer window.
---@param win integer Window handle.
---@return boolean is_file_window `true` if the window is a normal file buffer, `false` otherwise.
function M.is_file_window(win)
  return M.get_win_buftype(win) == '' -- '' means normal file buffer
end

---Get all normal file buffer windows in a tabpage.
---@param tabpage integer|nil Tabpage handle.  
---Defaults to `0` (current tabpage) if not provided.
---@return integer[] file_windows List of window handles for normal file buffers.
function M.get_file_windows(tabpage)
  local wins = vim.api.nvim_tabpage_list_wins(tabpage or 0)
  return vim.tbl_filter(M.is_file_window, wins)
end

return M
