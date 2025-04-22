local tailwindlsp_opts = {
  servers = {
    tailwindcss = {
      settings = {
        tailwindCSS = {
          lint = {
            invalidApply = false,
          },
        },
      },
    },
    cssls = {
      settings = {
        css = {
          validate = true,
          lint = {
            unknownAtRules = "ignore",
          },
        },
        scss = {
          validate = true,
          lint = {
            unknownAtRules = "ignore",
          },
        },
      },
    },
    volar = {
      settings = {
        css = {
          validate = true,
          lint = {
            unknownAtRules = "ignore",
          },
        },
        scss = {
          validate = true,
          lint = {
            unknownAtRules = "ignore",
          },
        },
      },
    },
  },
}

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
      ahk2 = {},
      gdscript = {},
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

    local zero_lsp = require('zero.lsp')

    if zero_lsp.is_enabled("denols") and zero_lsp.is_enabled("vtsls") then
      local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
      zero_lsp.disable("vtsls", is_deno)
      zero_lsp.disable("denols", function(root_dir, config)
        if not is_deno(root_dir) then
          config.settings.deno.enable = false
        end
        return false
      end)
    end
    local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")(vim.fn.getcwd())
    local is_tailwind = require("lspconfig.util").root_pattern("tailwind.config.js")(vim.fn.getcwd())
    if is_tailwind then
      servers = vim.tbl_deep_extend('force', servers, tailwindlsp_opts.servers)
    end

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          if server_name == 'denols' or server_name == 'vtsls' then
            if not is_deno then
              if server_name == 'denols' then
                return
              end
            else
              if server_name == 'vtsls' then
                return
              end
            end
          end
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for tsserver)
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          servers[server_name] = server
        end,
      },
    }

    local configs = require "lspconfig.configs"

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
    configs["ahk2"] = { default_config = ahk2_configs }

    for server_name, settings in pairs(servers) do
      require("lspconfig")[server_name].setup(settings)
    end
  end,
}
