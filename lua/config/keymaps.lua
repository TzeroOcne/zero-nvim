local zero = require('zero')

vim.keymap.set({ "n", "v" }, "<C-n>", "<cmd>nohl<cr>")
vim.keymap.set({ "n", "v" }, "<leader>ld", vim.lsp.buf.definition, { desc = "Go to lsp definition" })
vim.keymap.set({ "n", "v" }, "<leader>lr", vim.lsp.buf.references, { desc = "Go to lsp references" })
vim.keymap.set({ "v" }, "<C-c>", '"+y', { desc = "Yank visual to clipboard" })

-- LSP keymap
vim.keymap.set({ "n", "v" }, "<leader>cr", vim.lsp.buf.rename, { desc = 'LSP Rename' })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = 'Code Action' })

-- Buffer keymap
vim.keymap.set({ "n", "v" }, "<leader>bd", zero.bufremove, { desc = 'Remove buffer' })

-- Terminal key
local lazyterm = function() zero.terminal('zsh') end
vim.keymap.set({ 't' }, '<esc><esc>', '<C-\\><C-n>', { noremap = true, silent = true, desc = 'Enter normal mode' })
vim.keymap.set({ "n", "v" }, "<C-_>", lazyterm, { noremap = true, silent = true, desc = 'Toggle terminal' })
vim.keymap.set({ 't' }, "<C-_>", '<cmd>close<cr>', { noremap = true, silent = true, desc = 'Toggle terminal' })
