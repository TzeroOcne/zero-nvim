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
---@param start string
---@param entry string
---@return integer[]
function M.calculate_pos_score(start, entry)
  ---@type integer[]
  local positions = {}
  local last_pos = 0

  for i = 1, #start do
    local char = start:sub(i, i)
    local found_pos = entry:find(char, last_pos + 1)

    if found_pos then
      -- Score based on how early the character appears
      table.insert(positions, found_pos)
      last_pos = found_pos
    else
      -- Penalize if character not found in target string
      table.insert(positions, math.huge)
    end
  end

  return positions
end

---comment
---@param entry cmp.Entry
function M.entry_pos_score(entry)
  local replace_string = M.get_entry_replace_string(entry)
  if not replace_string then
    return nil
  end
  local filter = entry:get_filter_text()
  return M.calculate_pos_score(replace_string, filter)
end

---comment
---@param entry1 cmp.Entry
---@param entry2 cmp.Entry
---@return boolean|nil
function M.pos_score(entry1, entry2)
  local score1 = M.entry_pos_score(entry1)
  local score2 = M.entry_pos_score(entry2)

  if not score1 or not score2 then
    return nil
  end

  -- Compare element by element in the found positions arrays
  for i = 1, math.min(#score1, #score2) do
    if score1[i] ~= score2[i] then
      return score1[i] < score2[i]  -- Prefer smaller (earlier) positions
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
