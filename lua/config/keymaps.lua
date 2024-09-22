local zero = require('config.zero')

vim.keymap.set({ "n", "v" }, "<C-n>", "<cmd>nohl<cr>")
vim.keymap.set({ "n", "v" }, "<leader>ld", vim.lsp.buf.definition, { desc = "Go to lsp definition" })
vim.keymap.set({ "n", "v" }, "<leader>lr", vim.lsp.buf.references, { desc = "Go to lsp references" })

vim.keymap.set({ "n", "v" }, "<leader>cr", vim.lsp.buf.rename, { desc = 'LSP Rename' })

-- Buffer keymap
vim.keymap.set({ "n", "v" }, "<leader>bd", zero.bufremove, { desc = 'Remove buffer' })

-- Terminal key
vim.keymap.set({ 't' }, '<esc><esc>', '<C-\\><C-n>', { noremap = true, silent = true, desc = 'Enter normal mode' })
