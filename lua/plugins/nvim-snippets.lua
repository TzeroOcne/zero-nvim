return {
  "garymjr/nvim-snippets",
  opts = {
    friendly_snippets = true,
    search_paths = {
      vim.fn.stdpath('config') .. '/snippets',
      vim.fn.stdpath('config') .. '/.local/snippets',
    }
  },
  dependencies = { "rafamadriz/friendly-snippets" },
}
