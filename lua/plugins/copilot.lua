return {
  "zbirenbaum/copilot.lua",
  enabled = false,
  cmd = "Copilot",
  build = ":Copilot auth",
  event = "InsertEnter",
  opts = function()
    local opts = {
      suggestion = {
        enabled = false,
      },
      panel = { enabled = false },
      filetypes = {
        yaml = true,
      },
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
