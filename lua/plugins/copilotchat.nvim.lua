return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "canary",
  lazy = true,
  cmd = { "CopilotChat" },
  dependencies = {
    { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
    { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
  },
  opts = {
    -- See Configuration section for options
  },
  -- See Commands section for default commands if you want to lazy load on them
}
