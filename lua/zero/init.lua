-- @NOTE: This file must stay free of third-party dependencies (no require('snacks'), etc.)
--         so require('zero') is always safe to call without waiting for plugins to load.
--         Code that depends on plugins (Snacks, outline, etc.) lives in separate files
--         under lua/zero/ (e.g., terminal.lua, buffer.lua).
local M = {}

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

function M.get_zsh()
  return M.has_zsh() and "zsh.exe" or nil
end

function M.get_msys()
  local msystem = os.getenv('MSYSTEM')
  return os.getenv('MSYSTEM_PREFIX') and msystem and { "C:\\Windows\\System32\\cmd.exe ", "/c", "C:\\msys64\\msys2_shell.cmd -defterm -here -no-start -" .. msystem:lower() .. " -shell bash -c zsh" } or nil
end

function M.get_terminal()
  return M.get_msys() or M.get_zsh() or 'pwsh'
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

function M.get_line_last_char()
  return vim.api.nvim_get_current_line():sub(-1)
end

function M.smart_join()
end

function M.is_godot_project()
  local root = vim.fn.getcwd() -- or use lsp root: vim.lsp.buf.list_workspace_folders()[1]
  local project_file = root .. "/project.godot"
  local git_dir = root .. "/.git"

  return (vim.fn.filereadable(project_file) == 1) and (vim.fn.isdirectory(git_dir) == 1)
end

-- Function to check if the root directory contains a folder named .obsidian
function M.is_obsidian_project()
  local cwd = vim.fn.getcwd()
  return vim.fn.isdirectory(cwd .. "/.obsidian") == 1
end

function M.is_nvim_config()
  local cwd = vim.fn.getcwd()
  return vim.fn.fnamemodify(cwd, ":p") == vim.fn.fnamemodify(vim.fn.stdpath("config"), ":p")
end

function M.enable_blink()
  return true
    -- and not M.is_obsidian_project()
    -- and M.is_godot_project()
end

function M.is_tailwind_project()
  local cwd = vim.fn.getcwd()
  local has_config = require("lspconfig.util").root_pattern("tailwind.config.js")(cwd)
  local has_module = vim.fn.isdirectory(cwd .. "/node_modules/tailwindcss") == 1
  return has_config or has_module
end

-- Simple deterministic hash -> hex string
function M.simple_hash(str)
  local hash = 5381
  for i = 1, #str do
    hash = bit.bxor(bit.lshift(hash, 5) + hash, string.byte(str, i)) -- hash * 33 XOR char
    hash = bit.band(hash, 0xFFFFFFFF) -- keep 32-bit
  end
  return string.format("%08x", hash)
end

return M
