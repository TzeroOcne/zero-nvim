local M = {}

local lazy_util = require('lazy.util')

---@type table<string, LazyFloat>
local terminals = {}

---@param buf number?
function M.bufremove(buf)
  buf = buf or 0
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf

  if vim.bo.modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
    if choice == 0 or choice == 3 then -- 0 for <Esc>/<C-c> and 3 for Cancel
      return
    end
    if choice == 1 then -- Yes
      vim.cmd.write()
    end
  end

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_call(win, function()
      if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
        return
      end
      -- Try using alternate buffer
      local alt = vim.fn.bufnr("#")
      if alt ~= buf and vim.fn.buflisted(alt) == 1 then
        vim.api.nvim_win_set_buf(win, alt)
        return
      end

      -- Try using previous buffer
      local has_previous = pcall(vim.cmd, "bprevious")
      if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then
        return
      end

      -- Create new listed buffer
      local new_buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_win_set_buf(win, new_buf)
    end)
  end
  if vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.cmd, "bdelete! " .. buf)
  end
end

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

---@class LazyTermOpts: LazyCmdOptions
---@field interactive? boolean
---@field esc_esc? boolean
---@field ctrl_hjkl? boolean

-- Opens a floating terminal (interactive by default)
---@param cmd? string[]|string
---@param opts? LazyTermOpts
function M.terminal (cmd, opts)
  opts = vim.tbl_deep_extend('force', {
    ft = 'lazyterm',
    size = { width = 0.9, height = 0.9 },
    persistent = true,
  }, opts or {}, { persistent = true }) --[[@as LazyTermOpts]]

  local termkey = vim.inspect({ cmd = cmd or "shell", cwd = opts.cwd, env = opts.env, count = vim.v.count1 })

  if terminals[termkey] and terminals[termkey]:buf_valid() then
    terminals[termkey]:toggle()
  else
    terminals[termkey] = lazy_util.float_term(cmd, opts)
    local buf = terminals[termkey].buf

    vim.api.nvim_create_autocmd("BufEnter", {
      buffer = buf,
      callback = function()
        vim.cmd.startinsert()
      end,
    })

    vim.cmd('noh')
  end

  return terminals[termkey]
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
      M.terminal(choice)
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

local function is_file_buffer(buf)
  return vim.api.nvim_buf_is_loaded(buf) and
         vim.api.nvim_buf_get_name(buf) ~= "" and
         vim.api.nvim_get_option_value('buftype', { buf = buf }) == ""
end

local function prompt_action(buf)
  local buf_name = vim.api.nvim_buf_get_name(buf)
  local messages = "&All\n&Discard all\n&Yes (write)\n&No (discard)\n&Skip\n&Cancel"
  local choice = vim.fn.confirm(string.format("Save %s?", buf_name), messages)
  if choice == 1 then
    -- Write all
    return "write_all"
  elseif choice == 2 then
    -- Discard all
    return "discard_all"
  elseif choice == 3 then
    -- Write current buffer
    return "write"
  elseif choice == 4 then
    -- Discard current buffer
    return "discard"
  elseif choice == 5 then
    -- Skip closing current buffer
    return "skip"
  elseif choice == 6 then
    -- Cancel closing buffer process
    return "cancel"
  else
    -- Invalid input
    return prompt_action(buf)
  end
end

function M.close_all_file_buffers()
  outline.close()

  local buffers = vim.api.nvim_list_bufs()
  local action = ""

  for _, buf in ipairs(buffers) do
    if is_file_buffer(buf) then
      if action ~= "write_all" and action ~= "discard_all" then
        action = prompt_action(buf)
      end
      if action == "write" or action == "write_all" then
        vim.api.nvim_buf_call(buf, function()
          vim.cmd("write")
        end)
        M.bufremove(buf)
      elseif action == "discard" or action == "discard_all" then
        M.bufremove(buf)
      elseif action == "skip" then
        -- Skip this buffer, continue to next
      elseif action == "cancel" then
        break
      end
    end
  end
end

function M.close_all_file_buffers_non_visible()
  outline.close()

  local visible_buffers = {}
  local windows = vim.api.nvim_list_wins()
  for _, win in ipairs(windows) do
    local buf = vim.api.nvim_win_get_buf(win)
    visible_buffers[buf] = true
  end

  local buffers = vim.api.nvim_list_bufs()
  local action = ""
  for _, buf in ipairs(buffers) do
    if is_file_buffer(buf) and not visible_buffers[buf] then
      if action ~= "write_all" and action ~= "discard_all" then
        action = prompt_action(buf)
      end
      if action == "write" or action == "write_all" then
        vim.api.nvim_buf_call(buf, function()
          vim.cmd("write")
        end)
        M.bufremove(buf)
      elseif action == "discard" or action == "discard_all" then
        M.bufremove(buf)
      elseif action == "skip" then
        -- Skip this buffer, continue to next
      elseif action == "cancel" then
        break
      end
    end
  end
end

return M
