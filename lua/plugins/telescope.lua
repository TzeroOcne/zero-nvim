return {
  'nvim-telescope/telescope.nvim',
  -- tag = '0.1.8',
  -- or
  -- branch = '0.1.x',
  event = "VeryLazy",
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = function ()
    local builtin = require('telescope.builtin')
    return {
      { '<leader>f/', builtin.live_grep, desc = "Live grep" },
      { '<leader>f:', builtin.command_history, desc = "Find command" },
      { '<leader>fb', builtin.buffers, desc = "Find buffers" },
      { '<leader>ff', builtin.find_files, desc = "Find files" },
      { '<leader>fg', builtin.git_files, desc = "Find git files" },
      { '<leader>fm', builtin.marks, desc = "Find marks" },
    }
  end,
}
