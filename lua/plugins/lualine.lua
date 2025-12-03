return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    {
      'linrongbin16/lsp-progress.nvim',
      config = function()
        require('lsp-progress').setup({
          spin_update_time = 50,
          max_size = 50,
        })
      end
    },
  },
  opts = {
    options = {
      globalstatus = true,
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {
        {
          'filename',
          path = 1,
        },
      },
      lualine_x = {
        function()
          -- invoke `progress` here.
          return require('lsp-progress').progress()
        end,
        {
          function() return require("noice").api.status.mode.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
        },
        require('zero.lualine').cmp_source('codeium'),
        'encoding',
        'fileformat',
        'filetype',
      },
      lualine_y = {'progress', 'location'},
      lualine_z = {
        function()
          return " " .. os.date("%R")
        end,
      },
    },
  },
}
