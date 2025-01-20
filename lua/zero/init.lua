local M = {}
local snacks = require('snacks')

---@param name string
function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

---@param name string
function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

function M.has_zsh()
  return vim.fn.executable("zsh.exe") == 1
end

local terminals = {}

-- Opens a floating terminal (interactive by default)
---@param cmd? string | string[]
---@param opts? snacks.terminal.Opts| {create?: boolean}
function M.terminal (cmd, opts)
  opts = opts or {}
  local id = vim.inspect({ cmd = cmd, cwd = opts.cwd, env = opts.env, count = vim.v.count1 })
  local terminal = snacks.terminal(cmd, opts)
  terminals[id] = terminal
  return terminal
end

---@return string[]
function M.get_terminal_list()
  return vim.tbl_map(
    ---comment
    ---@param value string
    function (value)
      return load('return ' .. value)().cmd
    end,
    vim.tbl_keys(terminals)
  )
end

function M.select_terminal()
  return vim.ui.select(
    M.get_terminal_list(),
    {},
    function (choice)
      if choice then
        M.terminal(choice)
      end
    end
  )
end

---@class JSONContext
---@field depth? number

---@class JSONOptions
---@field max_depth? number
---@field excluded_keys? table<string>

-- Convert a table to a JSON string, with an option to limit depth using context
---@param tbl table The table to convert to JSON
---@param options? JSONOptions A table with options for JSON conversion
---@param context? JSONContext A table tracking the current context, including depth
---@return string A JSON-encoded string representing the input table
function M.table_to_json(tbl, options, context)
  local depth = context and context.depth or 1
  local max_depth = options and options.max_depth
  local excluded_keys = options and options.excluded_keys or {}
  local json_str = "{"
  local first = true
  for key, value in pairs(tbl) do
    if vim.tbl_contains(excluded_keys, key) then
      goto continue
    end
    if not first then
      json_str = json_str .. ","
    end
    first = false

    json_str = json_str .. '"' .. tostring(key) .. '":'

    if type(value) == "string" then
      json_str = json_str .. '"' .. tostring(value) .. '"'
    elseif type(value) == "table" then
      if not max_depth or depth < max_depth then
        json_str = json_str .. M.table_to_json(value, options, { depth = depth + 1 })
      else
        json_str = json_str .. '"' .. tostring(value) .. '"'
      end
    else
      json_str = json_str .. tostring(value)
    end
    ::continue::
  end
  json_str = json_str .. "}"
  return json_str
end

function M.write_to_pipe(name, data)
  -- Open the pipe file for writing
  local pipe, err = io.open("\\\\.\\pipe\\" .. name, "w")
  if not pipe then
    print("Error opening pipe: " .. err)
    return
  end

  -- Write data to the pipe
  pipe:write(data)

  -- Close the pipe
  pipe:close()
end

function M.get_char_before_cursor()
  -- Get the current buffer and the cursor position
  local bufnr = vim.api.nvim_get_current_buf()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0)) -- get cursor position (line, col)

  -- Get the line text (lines are 1-indexed, columns are 0-indexed)
  ---@type string
  local current_line = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1] or ""

  -- Get the character before the cursor
  ---@type string | nil
  local char_before_cursor = col > 0 and current_line:sub(col, col) or nil

  return char_before_cursor
end

local outline = require('outline');

---Check if a buffer is a file buffer
---@param buf integer
---@return boolean
local function is_file_buffer(buf)
  return vim.api.nvim_buf_is_loaded(buf) and
         vim.api.nvim_buf_get_name(buf) ~= "" and
         vim.api.nvim_get_option_value('buftype', { buf = buf }) == ""
end

function M.get_file_buffer_list()
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

function M.get_non_visible_file_buffer_list()
  local file_buffers = M.get_file_buffer_list()
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

function M.bufdelete()
  outline.close()

  snacks.bufdelete.delete()
end

function M.close_all_file_buffers()
  outline.close()

  snacks.bufdelete.delete({
    filter = is_file_buffer,
  })
end

function M.close_all_file_buffers_non_visible()
  outline.close()

  local buffers = M.get_non_visible_file_buffer_list()
  snacks.bufdelete.delete({
    filter = function (buf)
      return vim.tbl_contains(buffers, buf)
    end,
  })
end

function M.get_line_last_char()
  return vim.api.nvim_get_current_line():sub(-1)
end

function M.smart_join()
end

return M
