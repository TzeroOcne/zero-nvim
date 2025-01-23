return {
  "wurli/split.nvim",
  lazy = true,
  keys = {
    "gl",
    "gls",
    "gL",
    "gLS",
  },
  opts = {
    keymaps = {
      -- Other keymaps are available :) these ones will be used
      -- by default.
      ["gl"] = {
        pattern = ",",
        operator_pending = true,
        interactive = false,
      },
      ["gls"] = {
        pattern = ",",
        operator_pending = false,
        interactive = false,
      },
      ["gL"] = {
        pattern = ",",
        operator_pending = true,
        interactive = true,
      },
      ["gLS"] = {
        pattern = ",",
        operator_pending = false,
        interactive = true,
      },
    },
  },
}
