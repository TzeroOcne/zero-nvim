local M = {}

---@module 'blink.cmp'

local prioritzed_sources = {
  copilot = 1,
  codeium = 2,
}

---@type blink.cmp.SortFunction
function M.source(item_a, item_b)
  local source_a, source_b = item_a.source_name, item_b.source_name
  local index_a, index_b = prioritzed_sources[source_a], prioritzed_sources[source_b]
  if index_a or index_b then
    if index_a and index_b then
      return index_a < index_b
    end
    return index_a and true or false
  end
  return nil
end

return M
