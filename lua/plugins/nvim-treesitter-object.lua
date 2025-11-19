return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  -- enabled = false,
  -- branch = "master",
  -- dependencies = {
  --   'nvim-treesitter/nvim-treesitter',
  -- },
  opts = {},
  config = function()
    require('nvim-treesitter.configs').setup({
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in your grammar.
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['as'] = '@snippet.outer',
            ['is'] = '@snippet.inner',
          },
          -- You can choose the select mode (default is charwise 'v')
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
          },
        },
      },
    })
  end,
}
