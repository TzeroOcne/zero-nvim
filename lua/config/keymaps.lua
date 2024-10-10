local zero = require('zero')

vim.keymap.set({ "n", "v" }, "<C-n>", "<cmd>nohl<cr>")
vim.keymap.set({ "n", "v" }, "<leader>ld", vim.lsp.buf.definition, { desc = "Go to lsp definition" })
vim.keymap.set({ "n", "v" }, "<leader>lr", vim.lsp.buf.references, { desc = "Go to lsp references" })
vim.keymap.set({ "v" }, "<C-c>", '"+y', { desc = "Yank visual to clipboard" })

-- LSP keymap
vim.keymap.set({ "n", "v" }, "<leader>cr", vim.lsp.buf.rename, { desc = 'LSP Rename' })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = 'Code Action' })
vim.keymap.set({ "i" }, "<C-k>", vim.lsp.buf.signature_help, { desc = 'Signature Help' })

-- Cursor keymap
vim.keymap.set({ "n", "v" }, "<leader>vm", function ()
  local line = vim.fn.line('.')
  local win_width = vim.api.nvim_win_get_width(0)
  local line_width = vim.fn.virtcol('$') -- gets the visual column of the end of the line
  local middle_column

  if line_width < win_width then
    middle_column = math.floor(line_width / 2)
  else
    middle_column = math.floor(win_width / 2)
  end

  vim.api.nvim_win_set_cursor(0, {line, middle_column})
end, { noremap = true, silent = true })

-- Buffer keymap
vim.keymap.set({ "n", "v" }, "<leader>bd", zero.bufremove, { desc = 'Remove buffer' })
vim.keymap.set({ "n", "v" }, "<leader>bo", zero.close_all_file_buffers_non_visible, { desc = 'Remove non visible file buffer' })
vim.keymap.set({ "n", "v" }, "<leader>bx", zero.close_all_file_buffers, { desc = 'Remove file buffer' })

-- Terminal key
---comment
---@param cmd? string
---@return function
local function zeroterm(cmd)
  return function ()
    zero.terminal(cmd or 'zsh')
  end
end
vim.keymap.set({ 't' }, '<esc><esc>', '<C-\\><C-n>', { noremap = true, silent = true, desc = 'Enter normal mode' })
vim.keymap.set({ "n", "v" }, "<leader>tt", zero.select_terminal, { noremap = true, silent = true, desc = 'Select terminal' })
vim.keymap.set({ "n", "v" }, "<leader>tg", zeroterm('lazygit'), { noremap = true, silent = true, desc = 'Lazygit' })
vim.keymap.set({ "n", "v" }, "<C-_>", zeroterm(), { noremap = true, silent = true, desc = 'Toggle terminal' })
vim.keymap.set({ 't' }, "<C-_>", '<cmd>close<cr>', { noremap = true, silent = true, desc = 'Toggle terminal' })
