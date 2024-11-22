return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  event = "InsertEnter",
  opts = {
    suggestion = {
      enabled = false,
      -- enabled = not vim.g.ai_cmp,
      auto_trigger = true,
      hide_during_completion = false,
      -- keymap = {
      --   accept = "<M-l>",
      --   accept_word = false,
      --   accept_line = false,
      --   next = "<M-]>",
      --   prev = "<M-[>",
      --   dismiss = "<C-]>",
      -- },
      -- keymap = {
      --   accept = false, -- handled by nvim-cmp / blink.cmp
      --   next = "<M-]>",
      --   prev = "<M-[>",
      -- },
    },
    panel = { enabled = false },
  },
}
