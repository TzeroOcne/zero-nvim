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

  vim.cmd('bdelete!')
end, {})
