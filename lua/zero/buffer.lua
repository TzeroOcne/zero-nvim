---Check if a buffer is a file buffer
---@param buf integer
---@return boolean
local function is_file_buffer(buf)
  return vim.api.nvim_buf_is_loaded(buf) and
      vim.api.nvim_buf_get_name(buf) ~= "" and
      vim.api.nvim_get_option_value('buftype', { buf = buf }) == ""
end

local function get_file_buffer_list()
  local buffers = vim.api.nvim_list_bufs()
  ---@type integer[]
  local result = {}
  for _, buf in ipairs(buffers) do
    if is_file_buffer(buf) then
      result[#result + 1] = buf
    end
  end
  return result
end

local function get_non_visible_file_buffer_list()
  local file_buffers = get_file_buffer_list()
  ---@type table<integer, boolean>
  local visible_buffers = {}
  local windows = vim.api.nvim_list_wins()
  for _, win in ipairs(windows) do
    local buf = vim.api.nvim_win_get_buf(win)
    visible_buffers[buf] = true
  end
  ---@type integer[]
  local result = {}
  for _, buf in ipairs(file_buffers) do
    if not visible_buffers[buf] then
      result[#result + 1] = buf
    end
  end
  return result
end

local outline_ok, outline = pcall(require, 'outline')

local M = {}

function M.bufdelete()
  if outline_ok then
    outline.close()
  end

  local Snacks = require('snacks')
  Snacks.bufdelete.delete()
end

function M.close_all_file_buffers()
  if outline_ok then
    outline.close()
  end

  local Snacks = require('snacks')
  Snacks.bufdelete.delete({
    filter = is_file_buffer,
  })
end

function M.close_all_file_buffers_non_visible()
  if outline_ok then
    outline.close()
  end

  local buffers = get_non_visible_file_buffer_list()
  local Snacks = require('snacks')
  Snacks.bufdelete.delete({
    filter = function(buf)
      return vim.tbl_contains(buffers, buf)
    end,
  })
end

return M