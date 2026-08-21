return {
  'MeanderingProgrammer/render-markdown.nvim',
  -- enabled = not require('zero').is_obsidian_project(),
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  lazy = true,
  ft = "markdown",
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {},
}
