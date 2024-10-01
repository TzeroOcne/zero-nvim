vim.api.nvim_create_autocmd("FileType", {
  pattern = "dbout",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "<M-h>", "zh", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "<M-l>", "zl", { noremap = true, silent = true })
  end,
})
