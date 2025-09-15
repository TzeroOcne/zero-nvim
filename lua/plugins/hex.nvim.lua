return {
  'RaafatTurki/hex.nvim',
  lazy = true,
  cmd = {
    "HexToggle",
  },
  config = function()
    require('hex').setup()
  end
}
