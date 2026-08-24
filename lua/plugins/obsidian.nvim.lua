---@module 'obsidian'
return {
  "obsidian-nvim/obsidian.nvim",
  enabled = function()
    local zero = require('zero')
    return zero.is_obsidian_project() or zero.is_nvim_config()
  end,
  -- enabled = false,
  -- commit = "3c967d0",
  -- tag = "~v3.14.7",
  -- version = "3.15.0",
  lazy = false,
  -- event = function()
  --   if require("zero").is_obsidian_project() then
  --     return { "VimEnter", "BufReadPre", "BufNewFile" }
  --   end
  --
  --   return {}
  -- end,
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
      -- -- Toggle check-boxes.
      -- {
      --   "<leader>oc",
      --   function()
      --     return require("obsidian").util.toggle_checkbox()
      --   end,
      --   desc = "Interact Check",
      --   buffer = true,
      -- },
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

    ---@type obsidian.config
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
      frontmatter = {
        enabled = false,
      },
      ---@diagnostic disable-next-line: missing-fields
      ui = {
        enable = false
      },

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
