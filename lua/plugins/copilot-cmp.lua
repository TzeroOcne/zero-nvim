return {
  "zbirenbaum/copilot-cmp",
  enabled = function()
    local ok, zero = pcall(require, 'zero')
    return not (ok and zero.enable_blink())
  end,
  config = function ()
    require("copilot_cmp").setup()
  end
}
