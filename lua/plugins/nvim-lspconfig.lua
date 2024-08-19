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
  opts = {
    servers = {
      lua_ls = {
        settings = {},
      },
    },
  },
  config = function() end,
}
