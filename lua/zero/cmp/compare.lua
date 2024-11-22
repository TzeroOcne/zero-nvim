local M = {}

local zero = require('zero')
local types = require('cmp.types')

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

---@param entry cmp.Entry
function M.expand_matches(entry)
  ---@type (integer|nil)[]
  local position_list = {}
  for _, value in ipairs(entry.matches) do
    for i = value.word_match_start, value.word_match_end do
      position_list[#position_list+1] = i
    end
  end

  return position_list
end

---@type cmp.ComparatorFunction
function M.positions(entry1, entry2)
  local matches1 = M.expand_matches(entry1)
  local matches2 = M.expand_matches(entry2)

  for index = 1, math.min(#matches1, #matches2) do
    local pos1 = matches1[index]
    local pos2 = matches2[index]
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

  if #matches1 ~= #matches2 then
    local word = string.sub(entry1.context.cursor_before_line, entry1.source_offset)
    if #matches1 == #word then
      return true
    end
    if #matches2 == #word then
      return false
    end

    return #matches1 > #matches2
  end

  return nil
end

local kind_priority_map = {
  [types.lsp.CompletionItemKind.Field] = -6,
  [types.lsp.CompletionItemKind.Constant] = -5,
  [types.lsp.CompletionItemKind.Variable] = -4,
  [types.lsp.CompletionItemKind.Function] = -3,
  [types.lsp.CompletionItemKind.Class] = -2,
  [types.lsp.CompletionItemKind.Snippet] = -1,
  [types.lsp.CompletionItemKind.Text] = 100,
}

---@type cmp.ComparatorFunction
---@param entry1 cmp.Entry
---@param entry2 cmp.Entry
---@return boolean|nil
function M.compare_kind(entry1, entry2)
  local source1 = entry1.source.name;
  local source2 = entry2.source.name;
  local kind1 = entry1:get_kind() --- @type lsp.CompletionItemKind | number
  local kind2 = entry2:get_kind() --- @type lsp.CompletionItemKind | number
  kind1 = source1 == "copilot" and -100 or kind_priority_map[kind1] or kind1
  kind2 = source2 == "copilot" and -100 or kind_priority_map[kind2] or kind2
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
