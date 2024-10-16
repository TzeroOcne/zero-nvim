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

return M
