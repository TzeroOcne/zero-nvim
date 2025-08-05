return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  event = "InsertEnter",
  opts = function()
    local opts = {
      suggestion = {
        enabled = false,
      },
      panel = { enabled = false },
    }
    local exe = vim.fn.exepath("copilot-language-server")
    if exe ~= "" then
      opts.server = {
        type = "binary",
        custom_server_filepath = exe,
      }
    end

    return opts
  end,
}
