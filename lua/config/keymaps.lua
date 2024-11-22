local zero = require('zero')
local zero_lsp = require('zero.lsp')
local telescope = require('telescope.builtin')
local map = vim.keymap.set;
local snacks = require('snacks')

map({ "n", "v" }, "<C-n>", "<cmd>nohl<cr>")
map({ "n", "v" }, "<leader>ld", vim.lsp.buf.definition, { desc = "Go to lsp definition" })
map({ "n", "v" }, "<leader>lr", telescope.lsp_references, { desc = "Go to lsp references" })
map({ "v" }, "<C-c>", '"+y', { desc = "Yank visual to clipboard" })

-- LSP keymap
map({ "n", "v" }, "<leader>cr", vim.lsp.buf.rename, { desc = 'LSP Rename' })
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = 'Code Action' })
map({ "n", "v" }, "<leader>cA", zero_lsp.source_action, { desc = 'Source Action' })
map({ "i" }, "<C-k>", vim.lsp.buf.signature_help, { desc = 'Signature Help' })

-- Cursor keymap
map({ "n", "v" }, "<leader>vm", function ()
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
map({ "n", "v" }, "<leader>bd", zero.bufdelete, { desc = 'Remove buffer' })
map({ "n", "v" }, "<leader>bo", zero.close_all_file_buffers_non_visible, { desc = 'Remove non visible file buffer' })
map({ "n", "v" }, "<leader>bx", zero.close_all_file_buffers, { desc = 'Remove file buffer' })

-- Terminal key
---comment
---@param cmd? string
---@return function
local function zeroterm(cmd)
  return function ()
    zero.terminal(cmd or zero.has_zsh() and 'zsh' or 'pwsh')
  end
end
map({ 't' }, '<esc><esc>', '<C-\\><C-n>', { noremap = true, silent = true, desc = 'Enter normal mode' })
map({ "n", "v" }, "<leader>tt", zero.select_terminal, { noremap = true, silent = true, desc = 'Select terminal' })
map({ "n", "v" }, "<leader>tg", function () snacks.lazygit() end, { noremap = true, silent = true, desc = 'Lazygit' })
map({ "n", "v" }, "<C-_>", zeroterm(), { noremap = true, silent = true, desc = 'Toggle terminal' })
map({ 't' }, "<C-_>", '<cmd>close<cr>', { noremap = true, silent = true, desc = 'Toggle terminal' })

-- From LazyVim
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
