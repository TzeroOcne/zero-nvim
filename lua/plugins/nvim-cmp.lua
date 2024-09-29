local zero_compare = require('zero.cmp.compare')
local compare = require('cmp.config.compare');

return {
  "hrsh7th/nvim-cmp",
  version = false, -- last release is way too old
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    {
      "garymjr/nvim-snippets",
      opts = {
        friendly_snippets = true,
      },
      dependencies = { "rafamadriz/friendly-snippets" },
    },
    { "petertriho/cmp-git", opts = {} },
    {
      "mason.nvim",
      opts = { ensure_installed = { "sqlfluff" } },
    },
    { "williamboman/mason-lspconfig.nvim", config = function() end },
  },
  -- Not all LSP servers add brackets when completing a function.
  -- To better deal with this, LazyVim adds a custom option to cmp,
  -- that you can configure. For example:
  --
  -- ```lua
  -- opts = {
  --   auto_brackets = { "python" }
  -- }
  -- ```
  ---@module 'cmd'
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
    opts.snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    }
    local cmp = require("cmp")
    local auto_select = true
    return {
      auto_brackets = {}, -- configure any filetype to auto add brackets
      formatting = {
        ---@param vim_item vim.CompletedItem
        format = function(entry, vim_item)
          vim_item.dup = nil
          vim_item.menu = ({
            nvim_lsp = '[L]',
            path     = '[F]',
            buffer   = '[B]',
          })[entry.source.name]
          return vim_item
        end
      },
      completion = {
        completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
      },
      preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ["<C-CR>"] = function(fallback)
          cmp.abort()
          fallback()
        end,
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<M-m>"] = cmp.mapping(function()
          if cmp.visible_docs() then
            cmp.close_docs()
          else
            cmp.open_docs()
          end
        end, { "i" }),
      }),
      sources = cmp.config.sources({
        { name = "luasnip" },
        { name = "snippets" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "git" },
        { name = "lazydev", group_index = 0 },
      }, {
        { name = "buffer" },
      }),
      experimental = {
        ghost_text = {
          hl_group = "CmpGhostText",
        },
      },
      ---@type cmp.SortingConfig
      sorting = {
        priority_weight = 2,
        comparators = {
          -- compare_kind,
          -- compare.offset,
          compare.exact,
          -- compare.score,
          zero_compare.compare_pos_score,
          zero_compare.compare_kind,
          -- compare.scopes,
          compare.recently_used,
          compare.locality,
          -- compare.kind,
          -- compare.sort_text,
          compare.length,
          compare.order,
        },
      },
    }
  end,
}
