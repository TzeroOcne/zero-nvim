---@type table<string,string>
local highlight_map = {
  codeium = "ZeroCodeium",
  copilot = "ZeroCopilot",
}
local cmp_icon = require('zero.config').icons.cmp
local max_label_width = 60
local wp = require('zero.workspace')
local codeium_enabled = wp.get('codeium', true)
local sources_default = {
  "snippets",
  "lsp",
  "path",
  "buffer",
  "copilot",
  -- "codeium",
}
if codeium_enabled then
  sources_default[#sources_default + 1] = "codeium"
end

return {
  'saghen/blink.cmp',
  enabled = function()
    return require('zero').enable_blink()
  end,
  -- optional: provides snippets for the snippet source
  dependencies = {
    "rafamadriz/friendly-snippets",
    -- {
    --   "L3MON4D3/LuaSnip",
    --   version = "2.*",
    --   dependencies = { "rafamadriz/friendly-snippets" },
    --   opts = function(_, opts)
    --     require('luasnip.loaders.from_vscode').lazy_load()
    --     require('luasnip.loaders.from_vscode').lazy_load({
    --       paths = {
    --         -- Use the following paths to load snippets from your config directory
    --         -- or any other directory you prefer.
    --         -- You can also use `vim.fn.stdpath('config')` to get the config path.
    --         vim.fn.stdpath('config') .. '/snippets',
    --         vim.fn.stdpath('config') .. '/.local/snippets',
    --       },
    --     })
    --     require('luasnip').filetype_extend('typescriptreact', { 'html' })
    --     require('luasnip').filetype_extend('tsx', { 'html' })
    --
    --     return opts
    --   end,
    -- },
    "giuxtaposition/blink-cmp-copilot",
    -- "fang2hou/blink-copilot",
    {
      "saghen/blink.compat",
      opts = { enable_events = true },
    },
    {
      "Exafunction/codeium.nvim",
      enabled = codeium_enabled,
      -- dependencies = {
      --   "nvim-lua/plenary.nvim",
      -- },
      opts = { enable_cmp_source = true },
      -- config = function (_, opts)
      --   require('codeium.util').get_other_documents = require('zero.codeium').get_other_documents
      --   require("codeium").setup(opts)
      -- end,
    },
    { "nvim-tree/nvim-web-devicons", opts = {} },
    "onsails/lspkind.nvim",
    {
      "MattiasMTS/cmp-dbee",
      version = "ms/v2",
      -- dependencies = {
      --   {
      --     "kndndrj/nvim-dbee",
      --     dependencies = {
      --       "MunifTanjim/nui.nvim",
      --     },
      --     build = function()
      --       -- Install tries to automatically detect the install method.
      --       -- if it fails, try calling it with one of these parameters:
      --       --    "curl", "wget", "bitsadmin", "go"
      --       require("dbee").install()
      --     end,
      --     config = function()
      --       require("dbee").setup(--[[optional config]])
      --     end,
      --   }
      -- },
      ft = "sql", -- optional but good to have
      opts = {}, -- needed
    },
  },

  -- use a release tag to download pre-built binaries
  version = '1.*',
  -- commit = 'e08ae37', -- include exact and score for sorting
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
        ---@param cmp blink.cmp.API
        ---@return boolean|nil
        function(cmp)
          local next_idx = (cmp.get_selected_item_idx() or 0) + 1
          local items = cmp.get_items()
          if next_idx > #items then
            next_idx = 0
          end
          local next_item = next_idx > 0 and items[next_idx]
          local next_source = next_item and next_item.source_name
          if cmp.is_menu_visible() then
            return require("blink.cmp").select_next({ auto_insert = highlight_map[next_source] and false })
          elseif cmp.snippet_active() then
            return cmp.snippet_forward()
          end
        end,
        "fallback",
      },
      ["<S-Tab>"] = {
        ---@param cmp blink.cmp.API
        ---@return boolean|nil
        function(cmp)
          local prev_idx = (cmp.get_selected_item_idx() or 0) - 1
          local items = cmp.get_items()
          local prev_item = prev_idx > 0 and items[prev_idx]
          local prev_source = prev_item and prev_item.source_name
          if cmp.is_menu_visible() then
            return require("blink.cmp").select_prev({ auto_insert = highlight_map[prev_source] and false })
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
          auto_insert = true,
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
            label = {
              width = {
                max = max_label_width,
              },
            },
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
      default = sources_default,
      per_filetype = {
        sql = { 'snippets', 'dadbod', 'buffer', 'dbee' },
      },
      -- transform_items = function (context, items)
      --   local function context()
      --   end
      --   local matched_indices = require('blink.cmp.fuzzy').fuzzy_matched_indices(
      --     context.get_line(),
      --     context.get_cursor()[2],
      --     vim.tbl_map(function(item) return item.label end, items),
      --     require('blink.cmp.config').completion.keyword.range
      --   )
      --   ---@type table<number, { matched_indices: table<number>, item: blink.cmp.CompletionItem }>
      --   local contexted = {}
      --   for index, value in ipairs(items) do
      --     contexted[index] = {
      --       matched_indices = matched_indices[index],
      --       item = value,
      --     }
      --   end
      --   ---@param item blink.cmp.CompletionItem
      --   local function mincount(item)
      --     local length = #item.label
      --     local ratio = math.pow(length / max_label_width, 2)
      --     return math.ceil(length * (1 -))
      --   end
      --   table.sort(contexted, function (item_a, item_b)
      --     local matched_a = item_a.matched_indices
      --     local matched_b = item_b.matched_indices
      --   end)
      --   return items
      -- end,
      -- compat = { "cmp-dbee" },
      providers = {
        dbee = { name = "cmp-dbee", module = "blink.compat.source" },
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          -- module = "blink-copilot",
          score_offset = 200,
          async = true,
        },
        codeium = {
          name = "codeium",
          enabled = codeium_enabled and function ()
            return vim.bo.filetype ~= 'DressingInput'
          end,
          module = "codeium.blink",
          score_offset = 100,
          async = true,
          max_items = 1,
        },
        dadbod = { name = "dadbod", module = "vim_dadbod_completion.blink" },
        snippets = {
          ---@type blink.cmp.SnippetsOpts
          opts = {
            search_paths = {
              vim.fn.stdpath('config') .. '/snippets',
              vim.fn.stdpath('config') .. '/.local/snippets',
            },
            extended_filetypes = {
              jsx = { 'html', 'typescriptreact' },
            },
            get_filetype = function ()
              if require('zero.treesitter').in_jsx_context() then
                return "jsx"
              end
              return vim.bo.filetype
            end,
          },
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

        -- require('zero.cmp.blink.compare').source,

        'score',
        'sort_text',
      },
    },
    cmdline = {
      keymap = {
        ['<C-l>'] = { 'accept' },
      },
    },

    snippets = {
    --   preset = 'luasnip',
      -- active = function (snippet)
      --   vim.print({ snippet = snippet })
      --   return vim.snippet.active(snippet)
      -- end
    },
  },
  opts_extend = { "sources.default" },
  -- config = function (_, opts)
    -- local trigger = require('blink.cmp.completion.trigger').show_if_on_trigger_character
    -- local config = require('blink.cmp.config').completion.trigger
    --
    -- require('blink.cmp.completion.trigger').show_if_on_trigger_character = function (ctx)
    --   zerolog.log('blink cmp trigger start')
    --   zerolog.log(vim.json.encode({ opts = ctx, config = config }))
    --   trigger(ctx)
    --   zerolog.log('blink cmp trigger end')
    -- end
    -- require('blink.cmp.lib.event_emitter').new = require('zero.blink.event_emitter').new

    -- require('blink.cmp').setup(opts)
  -- end,
}
