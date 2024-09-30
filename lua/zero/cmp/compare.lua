local M = {}

local types = require('cmp.types')

---comment
---@param entry cmp.Entry
function M.get_entry_replace_string(entry)
  local range = entry:get_insert_range()
  if not range then
    return nil
  end
  local start_pos = range.start.character + 1
  local cursor = vim.api.nvim_win_get_cursor(0)
  local _, end_pos = unpack(cursor)
  return vim.api.nvim_get_current_line():sub(start_pos, end_pos)
end

---comment
---@param entry1 cmp.Entry
---@param entry2 cmp.Entry
---@return boolean|nil
function M.positions(entry1, entry2)
  local replace_string = M.get_entry_replace_string(entry1)
  local filter1 = entry1:get_filter_text()
  local filter2 = entry2:get_filter_text()

  if not replace_string then
    return nil
  end

  local pos1 = 0
  local pos2 = 0
  for i = 1, #replace_string do
    local char = replace_string:sub(i, i)
    pos1 = filter1:lower():find(char:lower(), pos1 + 1)
    pos2 = filter2:lower():find(char:lower(), pos2 + 1)

    if not pos1 or not pos2 then
      if pos1 then
        return true
      end
      if pos2 then
        return false
      end
      return nil
    end

    if pos1 ~= pos2 then
      return pos1 < pos2
    end
  end

  return nil
end

local kind_priority_map = {
  [types.lsp.CompletionItemKind.Field] = -2,
  [types.lsp.CompletionItemKind.Snippet] = -1,
  [types.lsp.CompletionItemKind.Text] = 100,
}

---@type cmp.ComparatorFunction
---@param entry1 cmp.Entry
---@param entry2 cmp.Entry
---@return boolean|nil
function M.compare_kind(entry1, entry2)
  local kind1 = entry1:get_kind() --- @type lsp.CompletionItemKind | number
  local kind2 = entry2:get_kind() --- @type lsp.CompletionItemKind | number
  kind1 = kind_priority_map[kind1] or kind1
  kind2 = kind_priority_map[kind2] or kind2
  if kind1 ~= kind2 then
    local diff = kind1 - kind2
    if diff < 0 then
      return true
    elseif diff > 0 then
      return false
    end
  end
  return nil
end

return M
