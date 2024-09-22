return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  ---@type wk.Opts
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below,
    defaults = {},
    icons = {
      group = "",
    },
    spec = {
      mode = { "n", "v" },
      {
        "<leader>f",
        desc = "Telescope Find",
        icon = {},
      },
      {
        "<leader>o",
        desc = "Obsidian",
        icon = {},
      },
      {
        "<leader>l",
        desc = "LSP",
        icon = {},
      },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
