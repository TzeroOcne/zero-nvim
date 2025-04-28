return {
  "zbirenbaum/copilot-cmp",
  enabled = function()
    return not require('zero').enable_blink()
  end,
  config = function ()
    require("copilot_cmp").setup()
  end
}
