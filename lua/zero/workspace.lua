local M = {}

local config_path = ".nnry-nvim.json"
local cached = {} -- always a table

-- Read entire file
local function read_file(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local content = f:read("*a")
  f:close()
  return content
end

-- Load and decode JSON config
function M.load()
  local cwd = vim.fn.getcwd()
  local full_path = cwd .. "/" .. config_path

  -- File missing → cached = empty table
  if vim.fn.filereadable(full_path) == 0 then
    cached = {}
    return cached
  end

  local content = read_file(full_path)
  if not content then
    cached = {}
    return cached
  end

  -- Safe JSON decode
  local ok, data = pcall(vim.json.decode, content)
  if not ok or type(data) ~= "table" then
    cached = {}
    return cached
  end

  cached = data
  return cached
end

-- Getter
---@param key any
---@param default? any
---@return any
function M.get(key, default)
  -- Ensure loaded at least once
  if not next(cached) then
    M.load()
  end

  if key == nil then
    return cached
  end

  local result = cached[key]
  if result ~= nil then
    return result
  end

  return default ~= nil and default or nil
end

return M

