return {
  "TzeroOcne/oklch-color-picker.nvim",
  -- enabled = false,
  event = "VeryLazy",
  version = "*",
  branch = "v-right",
  keys = {
    -- One handed keymap recommended, you will be using the mouse
    -- #f00 #0f0
    {
      "<leader>v",
      function() require("oklch-color-picker").pick_under_cursor() end,
      desc = "Color pick under cursor",
    },
  },
  ---@type oklch.Opts
  opts = {
    highlight = {
      style = 'virtual_right',

      ---Set virtual symbol (requires render to be set to 'virtual')
      --- '▮'|'■'|'▆'|'██'
      virtual_text = ' ██',
    },
  },
}
