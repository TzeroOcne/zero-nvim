return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
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
        {
          function() return require("noice").api.status.mode.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
        },
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
