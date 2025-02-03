---@module 'snacks'

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      terminal = {
        wo = {
          relativenumber = true,
          numberwidth = 5,
        },
        border = 'single',
      },
      lazygit = {
        wo = {
          relativenumber = false,
        },
      },
    },
    picker = {
      formatters = {
        file = {
          filename_first = true,
        },
      },
      layout = {
         layout = {
          width = 0.85,
          height = 0.9,
        },
      },
      -- jump = {
      --   reuse_win = true,
      -- },
    },
  },
  keys = {
    { '<leader>f/', function () Snacks.picker.grep() end , desc = 'Grep' },
    { '<leader>f:', function () Snacks.picker.command_history() end, desc = 'Find command' },
    { '<leader>ff', function () Snacks.picker.files() end, desc = 'Find file' },
    { '<leader>fg', function () Snacks.picker.git_files() end, desc = 'Find git files' },
    { '<leader>fb', function () Snacks.picker.buffers() end, desc = 'Find buffers' },
    { '<leader>fm', function () Snacks.picker.marks() end, desc = 'Find marks' },
    -- LSP
    { '<leader>ld', function () Snacks.picker.lsp_definitions() end, desc = 'Find marks' },
    { '<leader>lr', function () Snacks.picker.lsp_references() end, desc = 'Find marks' },
  },
}
