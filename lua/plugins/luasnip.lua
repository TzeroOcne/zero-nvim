return {
  "L3MON4D3/LuaSnip",
  lazy = true,
  dependencies = {
    {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    {
      "nvim-cmp",
      dependencies = {
        "saadparwaiz1/cmp_luasnip",
      },
    },
  },
  opts = {
    history = true,
    delete_check_events = "TextChanged",
  },
}
