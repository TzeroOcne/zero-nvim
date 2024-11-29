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

return M
