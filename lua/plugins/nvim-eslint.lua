return {
  'esmuellert/nvim-eslint',
  enabled = require('zero.workspace').use_nvim_eslint(),
  config = function()
    require('nvim-eslint').setup({})
  end,
}
