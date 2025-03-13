-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.o.wrap = false
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.fileformat = 'unix'
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.splitright = true
vim.o.splitbelow = true

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "tokyonight", "habamax" } },
  -- automatically check for plugin updates
  -- checker = { enabled = true },
})

require('config.filetype')
require('config.keymaps')
require('config.autocmd')
require('config.command')

-- Restore cursor to bar blink when exit
vim.cmd([[
augroup RestoreCursorShapeOnExit
    autocmd!
    autocmd VimLeave * set guicursor=a:ver30-iCursor-blinkwait300-blinkon200-blinkoff150
augroup END
]])

-- Set color scheme
vim.cmd([[
  colorscheme tokyonight-night
]])

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
