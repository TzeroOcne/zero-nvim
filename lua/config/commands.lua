---@module 'Snacks'
vim.api.nvim_create_user_command('Bdf', function()
  local bufname = vim.api.nvim_buf_get_name(0)
  
  if bufname == '' then
    print("No file associated with this buffer.")
    return
  end

  local file_exists = vim.loop.fs_stat(bufname) ~= nil
  if file_exists then
    os.remove(bufname)
    print("Deleted file: " .. bufname)
  else
    print("File does not exist: " .. bufname)
  end

  Snacks.bufdelete.delete({ force = true })
end, {})

-- Reload keymaps.lua
vim.api.nvim_create_user_command("ReloadKeymaps", function()
  dofile(vim.fn.stdpath("config") .. "/lua/config/keymaps.lua")
end, { desc = "Reload keymaps.lua" })

-- Reload commands.lua
vim.api.nvim_create_user_command("ReloadCommands", function()
  dofile(vim.fn.stdpath("config") .. "/lua/config/commands.lua")
end, { desc = "Reload commands.lua" })
