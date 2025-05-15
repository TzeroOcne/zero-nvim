---@module 'codeium'
local M = {}
local enums = require('codeium.enums')
local cutil = require('codeium.util')

local excluded_prefix = {
  'blink-',
  'snacks_',
}

---@param bufnr integer
---@return boolean
local function allowed_docs(bufnr)
  local filetype = vim.bo[bufnr].filetype
  for _, prefix in ipairs(excluded_prefix) do
    if vim.startswith(filetype, prefix) then
      return false
    end
  end
  return vim.api.nvim_buf_is_loaded(bufnr) and filetype ~= ''
end

local function buf_to_codeium(bufnr)
	local filetype = enums.filetype_aliases[vim.bo[bufnr].filetype] or vim.bo[bufnr].filetype or 'text'
	local language = enums.languages[filetype] or enums.languages.unspecified
	local line_ending = cutil.get_newline(bufnr)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)
	table.insert(lines, '')
	local text = table.concat(lines, line_ending)
	return {
		editor_language = filetype,
		language = language,
		text = text,
		line_ending = line_ending,
		absolute_uri = cutil.get_uri(vim.api.nvim_buf_get_name(bufnr)),
	}
end

---@param bufnr integer
function M.get_other_documents(bufnr)
  local other_documents = {}

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if allowed_docs(buf) and buf ~= bufnr then
      table.insert(other_documents, buf_to_codeium(buf))
    end
  end
  return other_documents
end

return M
