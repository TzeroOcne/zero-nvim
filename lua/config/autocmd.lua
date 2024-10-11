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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lazy",
  callback = function()
    local win = vim.api.nvim_get_current_win()
    vim.wo[win][0].cursorline = true
    vim.api.nvim_set_hl(0, "CursorLine", { underline = true })
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "PlenaryTestPopup",
    "grug-far",
    "help",
    "lspinfo",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
    "dbout",
    "gitsigns-blame",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      desc = "Quit buffer",
    })
  end,
})

-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   pattern = "*.au3",
--   callback = function()
--     vim.bo.filetype = "autoit"
--   end
-- })
