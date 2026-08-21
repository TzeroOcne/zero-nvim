return {
  "TzeroOcne/oklch-color-picker.nvim",
  -- enabled = false,
  event = "VeryLazy",
  version = "*",
  branch = "v-right",
  keys = {
    -- One handed keymap recommended, you will be using the mouse
    -- #f00 #0f0
    {
      "<leader>v",
      function() require("oklch-color-picker").pick_under_cursor() end,
      desc = "Color pick under cursor",
    },
  },
  ---@type oklch.Opts
  opts = {
    highlight = {
      style = 'virtual_right',

      ---Set virtual symbol (requires render to be set to 'virtual')
      --- '▮'|'■'|'▆'|'██'
      virtual_text = ' ██',
    },
  },
  config = function(_, opts)
    local highlight = require("oklch-color-picker.highlight")
    local original = highlight.highlight_lines

    highlight.highlight_lines = function(bufnr, lines, from_line, ft, buf_data)
      if ft == "markdown" then
        local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "markdown", { error = false })
        if ok and parser then
          local tree = parser:parse()[1]
          local root = tree:root()
          local query = vim.treesitter.query.parse("markdown", [[
            (fenced_code_block) @code
          ]])

          for i, _ in ipairs(lines) do
            local line_n = from_line + i - 1
            local inside_code = false
            for _, node, _ in query:iter_captures(root, bufnr, line_n, line_n + 1) do
              local s, _, e = node:range()
              if line_n >= s and line_n <= e then
                inside_code = true
                break
              end
            end
            if not inside_code then
              lines[i] = ""
            end
          end
        end
      end
      return original(bufnr, lines, from_line, ft, buf_data)
    end
    require("oklch-color-picker").setup(opts)
  end,
}
