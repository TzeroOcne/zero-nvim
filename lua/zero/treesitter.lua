local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

local jsx_return_parent = {
  return_statement = true,
  arrow_function = true,
}

function M.in_jsx_context()
  if not vim.bo.filetype:match("react$") then
    return false
  end

  local node = ts_utils.get_node_at_cursor()
  if not node then
    return false
  end

  local parent = node:parent()
  if node:type() == "parenthesized_expression" and
    parent and jsx_return_parent[parent:type()]
  then
    return true
  end

  while node do
    local t = node:type()
    if t:match("^jsx") or t == "jsx_element" or t == "jsx_fragment" then
      return true
    end
    node = node:parent()
  end
  return false
end

return M
