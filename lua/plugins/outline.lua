return {
  "hedyhli/outline.nvim",
  lazy = true,
  cmd = { "Outline", "OutlineOpen" },
  keys = { -- Example mapping to toggle outline
    { "<leader>lo", "<cmd>OutlineOpen<CR>", desc = "Toggle outline" },
    { "<leader>lO", "<cmd>OutlineClose<CR>", desc = "Toggle outline" },
  },
  opts = {
    -- Your setup opts here
    outline_window = {
      -- Vim options for the outline window
      show_numbers = true,
      show_relative_numbers = true,
    },
  },
}
