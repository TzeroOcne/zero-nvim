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
      sources = {
        explorer = {
          -- your explorer picker configuration comes here
          -- or leave it empty to use the default settings
          layout = {
            preset = 'sidebar',
            layout = {
              width = 0.2,
            },
          },
        },
      },
      -- jump = {
      --   reuse_win = true,
      -- },
    },
    lazygit = {
      config = {
        os = {
          edit = 'nvim --server ' .. vim.v.servername .. ' --remote {{filename}}',
          -- edit = 'nvim --server ' .. vim.v.servername .. ' --remote {{filename}} && nvim --server ' .. vim.v.servername .. ' --remote-send \'<C-\\><C-N>i\'',
          -- edit = 'nvim --server ' .. vim.v.servername .. ' --remote-send "<C-\\><C-N>:q<CR>" && nvim --server ' .. vim.v.servername .. ' --remote {{filename}}',
          -- edit = 'nvim --server ' .. vim.v.servername .. ' --remote-send "<C-\\><C-N>:e \\"{{filename}}\\"<CR>"',
          -- edit = 'nvim --server ' .. vim.v.servername .. ' --remote-send "<C-\\><C-N>:q<CR>:e \\"{{filename}}\\"<CR>"',
          -- edit = 'nvim --server ' .. vim.v.servername .. ' --remote-send "<C-\\><C-N>:q<CR>:echo 1<CR>"',
          -- editPreset = 'nvim',
        },
      },
    },
  },
  keys = {
    { '<leader>f/', function () Snacks.picker.grep() end , desc = 'Grep' },
    { '<leader>f:', function () Snacks.picker.command_history() end, desc = 'Find command' },
    { '<leader>ff', function () Snacks.picker.files() end, desc = 'Find file' },
    { '<leader>fg', function () Snacks.picker.git_files() end, desc = 'Find git files' },
    { '<leader>fh', function () Snacks.picker.files({ hidden = true }) end, desc = 'Find hidden files' },
    { '<leader>fb', function () Snacks.picker.buffers() end, desc = 'Find buffers' },
    { '<leader>fm', function () Snacks.picker.marks() end, desc = 'Find marks' },
    -- LSP
    { '<leader>ld', function () Snacks.picker.lsp_definitions() end, desc = 'Find definition' },
    { '<leader>lr', function () Snacks.picker.lsp_references() end, desc = 'Find references' },
    -- Explorer
    { '<leader>ee', function () Snacks.explorer({ auto_close = true }) end, desc = 'View Explorer' },
    { '<leader>eo', function () Snacks.explorer.open() end, desc = 'Open Explorer' },
    { '<leader>er', function () Snacks.explorer.reveal() end, desc = 'Reveal Explorer' },
  },
}
