---@module 'snacks'
---@type snacks.picker.Action.fn
local function smart_lsp_confirm (picker, item)
  picker:close()
  local file_path = item.file
  local pos = item.pos or { 1, 0 } -- default to line 1, column 0
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_get_current_buf()
  local wins = vim.api.nvim_tabpage_list_wins(0)

  -- Try to get target buffer
  local target_buf = item.buf
  if not target_buf or not vim.api.nvim_buf_is_loaded(target_buf) then
    target_buf = vim.fn.bufadd(file_path)
    vim.fn.bufload(target_buf)
    vim.api.nvim_set_option_value('buflisted', true, { buf = target_buf })
  end

  local target_win = current_win

  -- Only switch to another window if:
  -- 1. There are other windows
  -- 2. Current buffer is NOT the target buffer
  if target_buf ~= current_buf and #wins > 1 then
    for _, win in ipairs(wins) do
      if win ~= current_win then
        target_win = win
        break
      end
    end
  end
  vim.api.nvim_set_current_win(target_win)

  -- Set the buffer in the target window
  vim.api.nvim_win_set_buf(target_win, target_buf)

  -- Move cursor to the target position
  vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] })

  -- Center the cursor
  vim.api.nvim_feedkeys("zz", "n", false)
end

---@type snacks.picker.Action.fn
local function smart_buffer_confirm (picker, item)
  picker:close()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  ---@type integer[]
  local window_candidate = {}
  if item.info and item.info.windows then
    for _, win in ipairs(item.info.windows) do
      if vim.tbl_contains(wins, win) then
        window_candidate[#window_candidate + 1] = win
      end
    end
  end
  if #window_candidate > 0 then
    vim.api.nvim_set_current_win(window_candidate[1])
    return true
  end
  return picker:action("edit")
end

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      terminal = {
        wo = {
          relativenumber = true,
          numberwidth = 5,
        },
        border = 'single',
      },
      lazygit = {
        wo = {
          relativenumber = false,
        },
      },
    },
    picker = {
      formatters = {
        file = {
          filename_first = true,
        },
      },
      layout = {
         layout = {
          width = 0.85,
          height = 0.9,
        },
      },
      sources = {
        explorer = {
          -- your explorer picker configuration comes here
          -- or leave it empty to use the default settings
          layout = {
            preset = 'sidebar',
            layout = {
              width = 0.2,
            },
          },
        },
      },
      -- jump = {
      --   reuse_win = true,
      -- },
    },
    lazygit = {
      config = {
        os = {
          edit = 'nvim --server ' .. vim.v.servername .. ' --remote {{filename}}',
          -- edit = 'nvim --server ' .. vim.v.servername .. ' --remote {{filename}} && nvim --server ' .. vim.v.servername .. ' --remote-send \'<C-\\><C-N>i\'',
          -- edit = 'nvim --server ' .. vim.v.servername .. ' --remote-send "<C-\\><C-N>:q<CR>" && nvim --server ' .. vim.v.servername .. ' --remote {{filename}}',
          -- edit = 'nvim --server ' .. vim.v.servername .. ' --remote-send "<C-\\><C-N>:e \\"{{filename}}\\"<CR>"',
          -- edit = 'nvim --server ' .. vim.v.servername .. ' --remote-send "<C-\\><C-N>:q<CR>:e \\"{{filename}}\\"<CR>"',
          -- edit = 'nvim --server ' .. vim.v.servername .. ' --remote-send "<C-\\><C-N>:q<CR>:echo 1<CR>"',
          -- editPreset = 'nvim',
        },
      },
    },
  },
  keys = {
    { '<leader>f/', function () Snacks.picker.grep() end , desc = 'Grep' },
    { '<leader>fl', function () Snacks.picker.lines() end , desc = 'Find Lines' },
    { '<leader>fw', function () Snacks.picker.grep_word() end , desc = 'Find Words' },
    { '<leader>f:', function () Snacks.picker.command_history() end, desc = 'Find command' },
    { '<leader>ff', function () Snacks.picker.files() end, desc = 'Find file' },
    { '<leader>fg', function () Snacks.picker.git_files() end, desc = 'Find git files' },
    { '<leader>fh', function () Snacks.picker.files({ hidden = true }) end, desc = 'Find hidden files' },
    { '<leader>fb', function () Snacks.picker.buffers({ confirm = smart_buffer_confirm }) end, desc = 'Find buffers' },
    { '<leader>fm', function () Snacks.picker.marks() end, desc = 'Find marks' },
    { '<leader>fs', function () Snacks.picker.lsp_symbols() end, desc = 'Find LSP Symbols' },
    { '<leader>fS', function () Snacks.picker.lsp_symbols() end, desc = 'Find LSP Workspace Symbols' },
    -- LSP
    { '<leader>ld', function () Snacks.picker.lsp_definitions({ confirm = smart_lsp_confirm }) end, desc = 'Find definition' },
    { '<leader>lr', function () Snacks.picker.lsp_references({ confirm = smart_lsp_confirm }) end, desc = 'Find references' },
    -- Explorer
    { '<leader>ee', function () Snacks.explorer({ auto_close = true }) end, desc = 'View Explorer' },
    { '<leader>eo', function () Snacks.explorer.open() end, desc = 'Open Explorer' },
    { '<leader>er', function () Snacks.explorer.reveal() end, desc = 'Reveal Explorer' },
  },
}
