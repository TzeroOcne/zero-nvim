return {
  "epwalsh/obsidian.nvim",
  version = "*",  -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  keys = function ()
    return {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      {
        "<leader>of",
        function()
          return require("obsidian").util.gf_passthrough()
        end,
        desc = "Jump link",
        noremap = false,
        expr = true,
        buffer = true,
      },
      -- Toggle check-boxes.
      {
        "<leader>oc",
        function()
          return require("obsidian").util.toggle_checkbox()
        end,
        buffer = true,
      },
      -- Smart action depending on context, either follow link or toggle checkbox.
      {
        "<leader>oo",
        function()
          return require("obsidian").util.smart_action()
        end,
        buffer = true,
        expr = true,
      }
    }
  end,
  opts = function ()
    vim.o.conceallevel = 1

    return {
      workspaces = {
        {
          name = "buf-parent",
          path = function()
            return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
          end,
        },
      },
    }
  end,
}
