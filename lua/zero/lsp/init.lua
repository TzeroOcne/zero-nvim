---@module "lspconfig"
local M = {}

function M.source_action()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source" },
      diagnostics = {},
    },
  })
end

function M.organize_imports()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.organizeImports" },
      diagnostics = {},
    }
  })
end

---@return lspconfig.Config
function M.get_config(server)
  local configs = require("lspconfig.configs")
  return rawget(configs, server)
end

---@param server string
---@param cond fun( root_dir, config): boolean
function M.disable(server, cond)
  local util = require("lspconfig.util")
  local def = M.get_config(server)
  ---@diagnostic disable-next-line: undefined-field
  def.document_config.on_new_config = util.add_hook_before(def.document_config.on_new_config, function(config, root_dir)
    if cond(root_dir, config) then
      config.enabled = false
    end
  end)
end

function M.is_enabled(server)
  local c = M.get_config(server)
  return c and c.enabled ~= false
end

return M
