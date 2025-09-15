return {
  ---@module 'snacks'
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
  keys = function ()
    local window = require('zero.window')
    local do_action = setmetatable(
      {
        edit_split = true,
        edit_vsplit = true,
        edit_tab = true,
      },
      {
        __index = function() return false end
      }
    )

    ---Jumps if the action is handled,
    ---else opens or switches to the buffer in a preferred window,
    ---then moves the cursor to `item.pos`.
    ---@type snacks.picker.Action.fn
    local function smart_lsp_confirm(picker, item, action)
      picker:close()

      if do_action[action.name] then
        return Snacks.picker.actions.jump(picker, item, action)
      end

      local file_path = item.file
      local pos = item.pos or { 1, 0 }
      local current_win = vim.api.nvim_get_current_win()
      local current_buf = vim.api.nvim_get_current_buf()
      local wins = window.get_file_windows(0)

      -- Try to get target buffer
      local target_buf = item.buf
      if not target_buf or not vim.api.nvim_buf_is_loaded(target_buf) then
        target_buf = vim.fn.bufadd(file_path)
        vim.fn.bufload(target_buf)
        vim.api.nvim_set_option_value('buflisted', true, { buf = target_buf })
      end

      local target_win = current_win

      -- Prefer window in current tab that already shows the target buffer
      for _, win in ipairs(wins) do
        if win ~= current_win and vim.api.nvim_win_get_buf(win) == target_buf then
          target_win = win
          break
        end
      end

      -- If no window is showing the buffer and it's not the current one, prefer a different window
      if target_win == current_win and target_buf ~= current_buf and #wins > 1 then
        for _, win in ipairs(wins) do
          if win ~= current_win then
            target_win = win
            break
          end
        end
      end

      -- Switch to target window and set buffer
      vim.api.nvim_set_current_win(target_win)
      vim.api.nvim_win_set_buf(0, target_buf)
      vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] })
      vim.api.nvim_feedkeys("zz", "n", false)
    end

    ---Jumps if action is handled,
    ---else switches to an existing window
    ---in the current tab or opens the buffer.
    ---@type snacks.picker.Action.fn
    local function smart_buffer_confirm (picker, item, action)
      picker:close()

      if do_action[action.name] then
        return Snacks.picker.actions.jump(picker, item, action)
      end

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
      { '<leader>ldd', function () Snacks.picker.lsp_definitions() end, desc = 'Find definition' },
      { '<leader>ldj', function () Snacks.picker.lsp_definitions({ confirm = smart_lsp_confirm }) end, desc = 'Find definition (smart)' },
      { '<leader>lr', function () Snacks.picker.lsp_references({ confirm = smart_lsp_confirm }) end, desc = 'Find references' },
      -- Explorer
      { '<leader>ee', function () Snacks.explorer({ auto_close = true }) end, desc = 'View Explorer' },
      { '<leader>eo', function () Snacks.explorer.open() end, desc = 'Open Explorer' },
      { '<leader>er', function () Snacks.explorer.reveal() end, desc = 'Reveal Explorer' },
    }
  end,
}
