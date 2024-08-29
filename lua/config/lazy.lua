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

vim.keymap.set({ "n", "v" }, "<C-n>", "<cmd>nohl<cr>")
vim.keymap.set({ "n", "v" }, "gcd", vim.lsp.buf.definition)
vim.keymap.set({ "n", "v" }, "gcr", vim.lsp.buf.references)

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

-- Set color scheme
vim.cmd([[
  colorscheme tokyonight-night
]])

vim.api.nvim_set_hl(0, "Comment", { fg="#909090" })
vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='#009090', bold=true })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='#009090', bold=true })
vim.api.nvim_set_hl(0, 'LineNr', { fg='Cyan' })
vim.api.nvim_set_hl(0, 'NeoTreeNormal', { bg ='none' })
vim.api.nvim_set_hl(0, 'NeoTreeCursorLine', { link = 'none', bg ='none' })
