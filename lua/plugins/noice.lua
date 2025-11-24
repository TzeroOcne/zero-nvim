return {
  "folke/noice.nvim",
  event = "VeryLazy",
  --- @module 'noice'
  --- @type NoiceConfig
  opts = {
    lsp = {
      progress = {
        enabled = false,
      },
      signature = {
        auto_open = {
          enabled = false,
        },
      },
    },
    -- add any options here
    views = {
      cmdline_popup = {
        position = {
          row = 4,
          col = "50%"
        },
        size = {
          width = 60,
          height = "auto",
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = 6,
          col = "50%"
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        },
      },
    },
    routes = {
      {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = {
          skip = true,
        },
      },
    },
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    {
      "rcarriga/nvim-notify",
      opts = {
        stages = "static",
      },
    },
  }
}
