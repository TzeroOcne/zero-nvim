return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  -- commit = "3c967d0",
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
        desc = "Interact Check",
        buffer = true,
      },
      -- Smart action depending on context, either follow link or toggle checkbox.
      {
        "<leader>oo",
        function()
          return require("obsidian").util.smart_action()
        end,
        desc = "Interact",
        buffer = true,
        expr = true,
      }
    }
  end,
  opts = function ()
    vim.o.conceallevel = 1

    return {
      legacy_commands = false,
      workspaces = {
        {
          name = "no-vault",
          path = function()
            -- alternatively use the CWD:
            return assert(vim.fn.getcwd())
            -- return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
          end,
        },
      },
      -- see below for full list of options 👇

      -- Optional, boolean or a function that takes a filename and returns a boolean.
      -- `true` indicates that you don't want obsidian.nvim to manage frontmatter.
      disable_frontmatter = true,

      -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
      completion = {
        -- Enables completion using nvim_cmp
        nvim_cmp = false,
        -- Enables completion using blink.cmp
        blink = true,
        -- Trigger completion at 2 chars.
        min_chars = 2,
      },
    }
  end,
  setup = function (_, opts)
    require("obsidian").setup(opts)
  end,
}
