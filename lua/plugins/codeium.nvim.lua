local enabled = require('zero.workspace').get('codeium', true)

return {
  "Exafunction/windsurf.nvim",
  enabled = enabled,
  cmd = "Codeium",
  event = "InsertEnter",
  build = ":Codeium Auth",
  -- enabled = false,
  opts = {
    enable_cmp_source = false, -- vim.g.ai_cmp, -- or require('zero').enable_blink(),
    virtual_text = {
      enabled = not vim.g.ai_cmp,
      key_bindings = {
        accept = false, -- handled by nvim-cmp / blink.cmp
        next = "<M-]>",
        prev = "<M-[>",
      },
    },
  },
  config = function (opts)
    require('codeium.util').get_newline = function ()
      return "\n"
    end
    require('codeium.util').get_other_documents = require('zero.codeium').get_other_documents
    require('codeium').setup(opts)
  end,
}
