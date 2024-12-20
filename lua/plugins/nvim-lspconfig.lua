return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "mason.nvim",
      opts = { ensure_installed = { "sqlfluff" } },
    },
    { "williamboman/mason-lspconfig.nvim", config = function() end },
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    -- https://github.com/nvim-lua/kickstart.nvim/blob/186018483039b20dc39d7991e4fb28090dd4750e/init.lua#L559
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- Auto Hot Key section

    local ahk2_configs = {
      autostart = true,
      cmd = {
        "node",
        vim.fn.expand("$HOME/.local/lsp/ahk/server/dist/server.js"),
        "--stdio"
      },
      filetypes = { "ahk", "autohotkey", "ah2" },
      init_options = {
        locale = "en-us",
        InterpreterPath = "C:/Users/qadzi/Programs/autohotkey/2.0.2/v2/AutoHotkey64.exe",
        -- Same as initializationOptions for Sublime Text4, convert json literal to lua dictionary literal
        AutoLibInclude = "Disabled", -- or "Local" or "User and Standard" or "All"
        CommentTags = "^;;\\s*(?<tag>.+)",
        CompleteFunctionParens = false,
        Diagnostics = {
          ClassStaticMemberCheck = true,
          ParamsCheck = true
        },
        ActionWhenV1IsDetected = "Continue",
        FormatOptions = {
          array_style = "none",           -- or "collapse" or "expand"
          break_chained_methods = false,
          ignore_comment = false,
          indent_string = "\t",
          max_preserve_newlines = 2,
          brace_style = "One True Brace", -- or "Allman" or "One True Brace Variant"
          object_style = "none",          -- or "collapse" or "expand"
          preserve_newlines = true,
          space_after_double_colon = true,
          space_before_conditional = true,
          space_in_empty_paren = false,
          space_in_other = true,
          space_in_paren = false,
          wrap_line_length = 0
        },
        WorkingDirs = {},
        SymbolFoldingFromOpenBrace = false
      },
      single_file_support = true,
      flags = { debounce_text_changes = 500 },
      capabilities = capabilities,
    }

    -- https://github.com/nvim-lua/kickstart.nvim/blob/186018483039b20dc39d7991e4fb28090dd4750e/init.lua#L585
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
      },
      zls = {},
      gdscript = {
        name = "godot",
        cmd = {"ncat", "127.0.0.1", "6005"},
      },
    }
    local ok, result = pcall(require, 'local.lspconfig')
    if ok then
      servers = vim.tbl_deep_extend('force', servers, result)
    end

    require('mason').setup()

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua', -- Used to format Lua code
    })

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for tsserver)
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }

    local configs = require "lspconfig.configs"
    configs["ahk2"] = { default_config = ahk2_configs }
    local nvim_lsp = require("lspconfig")
    nvim_lsp.ahk2.setup({})
  end,
}
