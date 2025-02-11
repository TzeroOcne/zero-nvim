return {
  "catgoose/nvim-colorizer.lua",
  enabled = false,
  event = "BufReadPre",
  opts = { -- set to setup table
    user_default_options = {
      mode = 'virtualtext',
      tailwind = true,
      always_update = true,
    },
  },
}
