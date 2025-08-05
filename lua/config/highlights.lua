vim.api.nvim_set_hl(0, "ZeroAI", { fg = "#00aa00", bg = "NONE", ctermfg = 2, ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "ZeroCopilot",  { fg = "#00bb00", bg = "NONE", ctermfg = 10, ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "ZeroCodeium",  { fg = "#009900", bg = "NONE", ctermfg = 28, ctermbg = "NONE" })

vim.api.nvim_set_hl(0, 'Comment', { fg='#909090' })
-- NormalFloat   xxx guifg=#c0caf5 guibg=#1a1b26
vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'none', bg = 'none' })
-- FloatTitle    xxx guifg=#27a1b9 guibg=#1a1b26
vim.api.nvim_set_hl(0, 'FloatTitle', { link = 'none', bg = 'none' })
vim.api.nvim_set_hl(0, 'DiagnosticUnnecessary', { fg='#909090' })
-- FloatBorder   xxx guifg= guibg=#1a1b26
vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#27a1b9', bg = 'none' })
vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#009090', bold = true })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#009090', bold = true })
vim.api.nvim_set_hl(0, 'LineNr', { fg = 'Cyan' })
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#0080b0' })
vim.api.nvim_set_hl(0, 'NeoTreeNormal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { bg = 'none' })
vim.api.nvim_set_hl(0, 'SnacksNormal', { link = 'none', bg = 'none' })
vim.api.nvim_set_hl(0, 'SnacksPicker', { link = 'none', bg = 'none' })
vim.api.nvim_set_hl(0, 'NeoTreeCursorLine', { link = 'none', bg = 'none' })
vim.api.nvim_set_hl(0, 'TreesitterContext', { link = 'none', bg = 'none' })
vim.api.nvim_set_hl(0, 'TreesitterContextBottom', { underline = true, sp = 'grey' })
vim.api.nvim_set_hl(0, 'TreesitterContextLineNumberBottom', { underline=true, sp='grey' })
