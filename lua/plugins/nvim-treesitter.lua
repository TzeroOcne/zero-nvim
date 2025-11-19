return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  lazy = false,
  -- config = function ()
  --   local configs = require("nvim-treesitter.configs")
  --
  --   configs.setup({
  --     ensure_installed = {
  --       "git_config",
  --       "gitcommit",
  --       "git_rebase",
  --       "gitignore",
  --       "gitattributes",
  --       "sql",
  --       "vimdoc",
  --       "luadoc",
  --       "lua",
  --       "markdown",
  --     },
  --     sync_install = false,
  --     highlight = { enable = true },
  --     indent = { enable = true },
  --   })
  -- end,
  opts = {
    ensure_installed = {
      "git_config",
      "gitcommit",
      "git_rebase",
      "gitignore",
      "gitattributes",
      "sql",
      "vimdoc",
      "luadoc",
      "lua",
      "markdown",
    },
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
  },
}
