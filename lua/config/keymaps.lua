local Zero = require('zero')
local ZeroLsp = require('zero.lsp')
local map = vim.keymap.set;
local Snacks = require('snacks')

map({ "n", "v" }, "<C-n>", "<cmd>nohl<cr>")
map({ "v" }, "<C-c>", '"+y', { desc = "Yank visual to clipboard" })

-- LSP Code keymap
map({ "n", "v" }, "<leader>cr", vim.lsp.buf.rename, { desc = 'LSP Rename' })
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = 'Code Action' })
map({ "n", "v" }, "<leader>cA", ZeroLsp.source_action, { desc = 'Source Action' })
map({ "n", "v" }, "<leader>co", ZeroLsp.organize_imports, { desc = 'Organize Import' })
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
map({ "n", "v" }, "<leader>bss", function () Snacks.scratch() end, { desc = 'Toggle scratch buffer' })
map({ "n", "v" }, "<leader>bsm", function ()
  Snacks.scratch({
    ft = "markdown"
  })
end, { desc = 'Toggle markdown scratch buffer' })
map({ "n", "v" }, "<leader>bS", function () Snacks.scratch.select() end, { desc = 'Select scratch buffer' })
map({ "n", "v" }, "<leader>bd", Zero.bufdelete, { desc = 'Remove buffer' })
map({ "n", "v" }, "<leader>bo", Zero.close_all_file_buffers_non_visible, { desc = 'Remove non visible file buffer' })
map({ "n", "v" }, "<leader>bx", Zero.close_all_file_buffers, { desc = 'Remove file buffer' })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tab split<cr>", { desc = "Open Buffer to New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Terminal key
---comment
---@param cmd? string
---@return function
local function zeroterm(cmd)
  return function ()
    if not Zero.close_open_terminal_buffer() then
      Zero.terminal(cmd or Zero.get_terminal())
    end
  end
end
map({ 't' }, '<esc><esc>', '<C-\\><C-n>', { noremap = true, silent = true, desc = 'Enter normal mode' })
map({ "n", "v" }, "<leader>tt", Zero.select_terminal, { noremap = true, silent = true, desc = 'Select terminal' })
map({ "n", "v" }, "<leader>tg", function () Snacks.lazygit() end, { noremap = true, silent = true, desc = 'Lazygit' })
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

-- Quick line navigation
map({ "n", "v" }, "<leader>hh", "^", { desc = "Start of line" })
map({ "n", "v" }, "<leader>hl", "$", { desc = "End of line" })

-- Markdown actions
map("x", "<leader>oc", "<Esc><cmd>silent '<,'>s/\\[ \\]/[x]/g | noh<CR>", { silent = true })

-- Insert action
map({ "n", "v" }, "<leader>io", "i<cr><esc>O", { desc = "End of line" })
map({ "n", "v" }, "<leader>ao", "a<cr><esc>O", { desc = "End of line" })
map({ "n", "v" }, "<leader>iO", function()
  vim.api.nvim_buf_set_lines(0, vim.fn.line('.'), vim.fn.line('.'), false, {""})
end, { desc = "Insert Line Below" })
map("i", "<C-j>", function()
  local row = vim.fn.line(".")
  vim.api.nvim_buf_set_lines(0, row, row, false, { "" })
end, { desc = "Insert line below (stay in place)" })
