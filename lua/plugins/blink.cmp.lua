---@type table<string,string>
local highlight_map = {
  codeium = "ZeroCodeium",
  copilot = "ZeroCopilot",
}
local cmp_icon = require('zero.config').icons.cmp

return {
  'saghen/blink.cmp',
  enabled = function()
    return require('zero').enable_blink()
  end,
  -- optional: provides snippets for the snippet source
  dependencies = {
    "rafamadriz/friendly-snippets",
    "giuxtaposition/blink-cmp-copilot",
    {
      "saghen/blink.compat",
      opts = { enable_events = true },
    },
    {
      "Exafunction/codeium.nvim",
      opts = { enable_cmp_source = true },
    },
    { "nvim-tree/nvim-web-devicons", opts = {} },
    "onsails/lspkind.nvim",
  },

  -- use a release tag to download pre-built binaries
  version = '1.*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
      preset = 'enter',
      -- https://www.reddit.com/r/neovim/comments/1htjg99/comment/m5dtwf1
      -- https://github.com/WizardStark/dotfiles/blob/1c48ac53a4c3203aaa6b1c74d61334d78a10c777/home/.config/nvim/lua/config/editor/blink_cmp.lua#L7
      ["<Tab>"] = {
        function(cmp)
          if cmp.is_menu_visible() then
            return require("blink.cmp").select_next()
          elseif cmp.snippet_active() then
            return cmp.snippet_forward()
          end
        end,
        "fallback",
      },
      ["<S-Tab>"] = {
        function(cmp)
          if cmp.is_menu_visible() then
            return require("blink.cmp").select_prev({  })
          elseif cmp.snippet_active() then
            return cmp.snippet_backward()
          end
        end,
        "fallback",
      },
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = {
      trigger = {
        show_in_snippet = false,
      },
      list = {
        selection = {
          preselect = false,
        --   auto_insert = false,
        },
      },
      documentation = { auto_show = false },
      menu = {
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind", "source_name", gap = 2 },
          },
          components = {
            kind_icon = {
              text = function(ctx)
                local icon = ctx.kind_icon
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                  if dev_icon then
                    icon = dev_icon
                  end
                else
                  icon = cmp_icon[ctx.source_name:lower()] or require("lspkind").symbolic(ctx.kind, {
                    mode = "symbol",
                  })
                end

                return icon .. ctx.icon_gap
              end,

              -- Optionally, use the highlight groups from nvim-web-devicons
              -- You can also add the same function for `kind.highlight` if you want to
              -- keep the highlight groups in sync with the icons.
              highlight = function(ctx)
                local hl = ctx.kind_hl
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                  if dev_icon then
                    hl = dev_hl
                  end
                end
                return hl
              end,
            },
            kind = {
              text = function (ctx)
                if ctx.source_name == "codeium" then
                  return "Codeium"
                end
                return ctx.kind
              end,
              highlight = function (ctx)
                return highlight_map[ctx.source_name:lower()] or ctx.kind_hl
              end,
            },
          },
        },
      },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = {
        "snippets",
        "lsp",
        "path",
        "buffer",
        "copilot",
        "codeium",
      },
      per_filetype = {
        sql = { 'snippets', 'dadbod', 'buffer' },
      },
      providers = {
        dadbod = { name = "dadbod", module = "vim_dadbod_completion.blink" },
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          score_offset = 100,
          async = true,
        },
        codeium = {
          name = "codeium",
          module = "codeium.blink",
          score_offset = 200,
          async = true,
          -- Best feature of blink
          max_items = 4,
        },
      },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = {
      implementation = "prefer_rust_with_warning",
      sorts = {
        -- (optionally) always prioritize exact matches
        'exact',

        require('zero.cmp.blink.compare').source,

        'score',
        'sort_text',
      },
    }
  },
  opts_extend = { "sources.default" }
}
