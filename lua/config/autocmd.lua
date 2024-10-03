vim.api.nvim_create_autocmd("FileType", {
  pattern = "dbout",
  callback = function()
    local win = vim.api.nvim_get_current_win()
    vim.wo[win][0].cursorline = true
    vim.api.nvim_set_hl(0, "CursorLine", { underline = true })
    vim.api.nvim_buf_set_keymap(0, "n", "<M-h>", "zh", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "<M-l>", "zl", { noremap = true, silent = true })
  end,
})
