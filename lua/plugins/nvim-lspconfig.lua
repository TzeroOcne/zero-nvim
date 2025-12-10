---@module "mason-registry"
local tailwindlsp_opts = {
  servers = {
    svelte = {
      settings = {
        css = {
          validate = true,
          lint = {
            unknownAtRules = "ignore",
          },
        },
      },
    },
    tailwindcss = {
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
  tag = "v2.5.0",
  dependencies = {
    {
      "mason-org/mason.nvim",
      -- opts = {}
    },
    {
      "mason-org/mason-lspconfig.nvim",
    },
    "hrsh7th/cmp-nvim-lsp",
    { "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },
    "b0o/schemastore.nvim",
  },
  config = function()
    -- https://github.com/nvim-lua/kickstart.nvim/blob/186018483039b20dc39d7991e4fb28090dd4750e/init.lua#L559
    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- https://github.com/nvim-lua/kickstart.nvim/blob/3338d3920620861f8313a2745fd5d2be39f39534/init.lua#L662C1-L663C1
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    ---@type table<string, vim.lsp.Config>
    local servers = {
      gopls = {
        settings = {
          gopls = {
            -- buildFlags = { "-tags=air" },
          },
        },
      },
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
      },
      zls = {
        cmd = {
          vim.fn.expand("$HOME/Programs/zls/$ZIG_VERSION/zls.exe"),
        },
      },
      ahk2 = {},
      gdscript = {},
      omnisharp = {
        cmd = { "omnisharp" },
        handlers = {
          ["textDocument/definition"] = function(...)
            return require("omnisharp_extended").handler(...)
          end,
        },
        enable_roslyn_analyzers = true,
        organize_imports_on_format = true,
        enable_import_completion = true,
      },
      gleam = {},
      powershell_es = {
        cmd = {
          'pwsh.exe',
          '-NoLogo',
          '-NoProfile',
          '-Command',
          vim.fn.stdpath('data') .. '/mason/packages/powershell-editor-services/PowerShellEditorServices/Start-EditorServices.ps1',
        },
      },
      jsonls = {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas {
            },
            validate = { enable = true },
          },
        },
      },
      yamlls = {
        settings = {
          yaml = {
            schemaStore = {
              -- You must disable built-in schemaStore support if you want to use
              -- this plugin and its advanced options like `ignore`.
              enable = false,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = "",
            },
            schemas = require('schemastore').yaml.schemas {
              select = {
                'mise',
              },
            },
          },
        },
      }
    }
    local ok, result = pcall(require, 'local.lspconfig')
    if ok then
      servers = vim.tbl_deep_extend('force', servers, result)
    end

    -- print(vim.env.PATH)
    require('mason').setup()
    -- print(vim.env.PATH)

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    ---@type string[]
    local ensure_installed = vim.tbl_keys(servers)
    ensure_installed = vim.tbl_filter(
      function(server_name)
        return not vim.list_contains(
          {
            "gleam",
            "gdscript",
            "ahk2",
          },
          server_name
        )
      end,
      ensure_installed
    )

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
    local is_tailwind = require('zero').is_tailwind_project()
    if is_tailwind then
      servers = vim.tbl_deep_extend('force', servers, tailwindlsp_opts.servers)
    end
    local mason_exclude = vim.tbl_keys(servers)
    mason_exclude = vim.tbl_filter(
      function(server_name)
        if server_name == 'denols' or server_name == 'vtsls' then
          if not is_deno then
            if server_name == 'denols' then
              return true
            end
          else
            if server_name == 'vtsls' then
              return true
            end
          end
        end
        return false
      end,
      mason_exclude
    )

    require('mason-lspconfig').setup {
      ensure_installed = ensure_installed,
      automatic_enable = { exclude = mason_exclude },
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
        InterpreterPath = vim.fn.expand("$HOME/Programs/autohotkey/2.0.2/v2/AutoHotkey64.exe"),
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
          ignore_comment = true,
          indent_string = "\t",
          max_preserve_newlines = 2,
          brace_style = "One True Brace", -- or "Allman" or "One True Brace Variant"
          object_style = "none",          -- or "collapse" or "expand"
          preserve_newlines = true,
          space_after_double_colon = false,
          space_before_conditional = true,
          space_in_empty_paren = false,
          space_in_other = false,
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
      vim.lsp.config(server_name, settings)
    end
  end,
}
