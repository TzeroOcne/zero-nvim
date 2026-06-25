# zero-nvim — Agent Guide

A modular Neovim configuration for Windows, using **lazy.nvim** as the plugin manager.
The config is named "zero-nvim" and sometimes uses `nryy` as an internal namespace (log file, notification titles, workspace config filename).

---

## Directory Structure

```
├── init.lua                    # Entry point: boots lazy.nvim, imports config + plugins
├── lua/
│   ├── config/
│   │   ├── lazy.lua            # Bootstrap + lazy.nvim setup, global vim.opt/vim.g
│   │   ├── keymaps.lua         # All keymappings
│   │   ├── autocmds.lua        # Autocommands (Godot RPC, dbout, gitcommit, etc.)
│   │   ├── commands.lua        # Custom user commands (:Bdf, :ReloadKeymaps, etc.)
│   │   ├── filetypes.lua       # Custom filetype detection
│   │   └── highlights.lua      # Custom highlight groups (ZeroAI, ZeroCopilot, etc.)
│   ├── plugins/*.lua           # Each file = one lazy.nvim plugin spec
│   └── zero/                   # Core utility library ("zero" namespace)
│       ├── init.lua            # Terminal mgmt, buffer ops, project detection, JSON, pipe I/O
│       ├── config.lua          # Icon definitions for cmp, diagnostics, git, DAP, etc.
│       ├── log.lua             # File-based logger (writes to nvim-data/nryy.log, gated by vim.g.zerolog)
│       ├── window.lua          # Window/buffer type helpers
│       ├── workspace.lua       # Per-project config via .nnry-nvim.json
│       ├── treesitter.lua      # JSX context detection via treesitter
│       ├── lualine.lua         # Lualine status component factories
│       ├── pipe.lua            # Windows named pipe management (kills + waits)
│       ├── lsp/init.lua        # LSP utilities (source_action, organize_imports, disable)
│       ├── cmp/init.lua        # nvim-cmp snippet parsing, auto-brackets, setup wrapper
│       ├── cmp/compare.lua     # Custom nvim-cmp sort comparators
│       ├── cmp/context.lua     # Placeholder (empty)
│       ├── cmp/source.lua      # Placeholder (empty)
│       ├── cmp/blink/compare.lua # blink.cmp sort comparator (prioritizes copilot/codeium)
│       └── blink/event_emitter.lua # Custom blink.cmp event emitter with autocmd support
├── snippets/                   # VSCode-style snippets (golang.json, markdown.json)
│   └── package.json            # Snippet registry
├── queries/
│   ├── typescript/injections.scm   # Empty
│   └── svelte/textobjects.scm      # Treesitter textobjects for Svelte snippets
├── README.md
└── .editorconfig               # LF endings, 2-space indent
```

---

## Plugin Spec Pattern

Every file in `lua/plugins/` returns a **lazy.nvim spec table**. The project uses two styles:

**Simple** — just opts:
```lua
return {
  "lewis6991/gitsigns.nvim",
  opts = { current_line_blame = true },
}
```

**Full** — with deps, keys, conditional loading:
```lua
return {
  'saghen/blink.cmp',
  enabled = function()
    local ok, zero = pcall(require, 'zero')
    return ok and zero.enable_blink()
  end,
  version = '1.*',
  dependencies = { ... },
  opts = { ... },
}
```

**Key conventions:**
- `lazy = false` for plugins loaded at startup (snacks.nvim, oil.nvim, nvim-treesitter)
- `event = "VeryLazy"` for most others (which-key, noice, flash)
- `optional = true` for plugins that integrate with another (conform.lua extending linters)
- `enabled = function()` for conditional loading (blink vs nvim-cmp, obsidian, nvim-eslint)
- `main = "ibl"` when the plugin's module name differs from its repo name
- `--- @module '...'` annotations for LSP type checking

---

## Architecture & Flow

```
init.lua
  └─ config/lazy.lua (bootstrap lazy.nvim, set global opts)
       └─ lazy.nvim loads every file in lua/plugins/
            └─ Each plugin spec defines its own opts/config/keys
  └─ config/filetypes.lua
  └─ config/keymaps.lua
  └─ config/autocmds.lua
  └─ config/commands.lua
  └─ config/highlights.lua
  └─ colorscheme tokyonight-night
```

The `lua/zero/` modules are a shared utility library — they don't auto-load on startup. Plugins and config files `require('zero')` as needed.

---

## Completion Architecture (Important)

Two completion engines coexist **mutually exclusively**:

| Engine | File | Guard |
|--------|------|-------|
| **blink.cmp** (default) | `plugins/blink.cmp.lua` | `enabled = zero.enable_blink()` → always `true` |
| nvim-cmp (fallback) | `plugins/nvim-cmp.lua` | `enabled = not zero.enable_blink()` |

`zero.enable_blink()` currently always returns `true` (but has commented-out Obsidian/Godot gating code).

---

## Keymaps & Prefixes

| Prefix | Group | Defined in |
|--------|-------|------------|
| `<leader>f` | Picker (Snacks) | `plugins/snacks.nvim.lua` |
| `<leader>e` | Explorer | `plugins/snacks.nvim.lua` |
| `<leader>b` | Buffer ops | `config/keymaps.lua` |
| `<leader>c` | LSP code actions | `config/keymaps.lua` |
| `<leader>l` | LSP navigation | `plugins/snacks.nvim.lua` |
| `<leader>t` | Terminal | `config/keymaps.lua` |
| `<leader>x` | Diagnostics (Trouble) | `plugins/trouble.lua` |
| `<leader>o` | Obsidian | `plugins/obsidian.nvim.lua` |
| `<leader><tab>` | Tab management | `config/keymaps.lua` |
| `<leader>zh` | Scroll viewport left | `config/keymaps.lua` |
| `<leader>vm` | Cursor to column middle | `config/keymaps.lua` |
| `<leader>io` / `<leader>ao` | Insert line above/below | `config/keymaps.lua` |

Leader is space, local leader is `\`. `which-key.nvim` group labels are in `plugins/which-key.lua`.

---

## LSP

Configured manually via `plugins/nvim-lspconfig.lua` (not using mason-lspconfig's auto-setup for most servers). **Servers configured:**

- **vtsls** (TypeScript/JS) — explicit binary path via `mason/packages`
- **eslint** — explicit binary path
- **tailwindcss** — explicit binary path
- **gopls**, **lua_ls**, **zls**, **zls**, **ahk2**, **gdscript**, **omnisharp**, **gleam**, **powershell_es**, **jsonls** (with schemastore), **yamlls**, **svelte**, **cssls**, **volar**
- **Autohotkey** LSP: started manually via autocmd in `config/autocmds.lua`
- **AutoIt** LSP: started manually from a HOME path

Uses `blink.cmp.get_lsp_capabilities()` (not cmp-nvim-lsp's capabilities).

To disable an LSP for certain projects: `require('zero.lsp').disable(server, cond_fn)`.

---

## Project Detection

Functions in `lua/zero/init.lua`:

| Function | Detection Method |
|----------|-----------------|
| `is_godot_project()` | `project.godot` exists + `.git` exists |
| `is_obsidian_project()` | `.obsidian/` directory exists in cwd |
| `is_tailwind_project()` | `tailwind.config.js` or `node_modules/tailwindcss` |
| `is_deno()` | `deno.json`/`deno.jsonc` root pattern OR `.nnry-nvim.json` key |

Per-project config lives in `.nnry-nvim.json` (read by `lua/zero/workspace.lua`):
```json
{ "deno": true, "nvim-eslint": true }
```

`nvim-eslint.lua` plugin is enabled/disabled based on `workspace.use_nvim_eslint()`.

---

## Windows-Specific Details

- Shell is explicitly set to `cmd.exe` with `/c` flag
- Terminal detection: tries MSYS2 → zsh.exe → pwsh
- Named pipes use `\\.\pipe\` syntax
- Godot projects get a RPC server on a deterministic named pipe + batch file (`nvim-remote.bat`)
- edit command for lazygit uses `nvim --server` remote

---

## Highlight Groups

Custom highlights in `lua/config/highlights.lua`:

- `ZeroAI`, `ZeroCopilot`, `ZeroCodeium` — AI source colors (green shades)
- `Comment` → `#909090`
- `NormalFloat`, `FloatTitle`, `FloatBorder` — transparency
- `LineNrAbove`, `LineNrBelow`, `LineNr` — custom line number colors
- `CmpGhostText`, `TreesitterContext*`, `NeoTree*`, `Snacks*` — various UI tweaks

---

## Commands

No Makefile, CI, or test framework found. **This is a Neovim config — no build/test commands exist.**

User commands defined:
- `:Bdf` — Delete current buffer and its file on disk
- `:ReloadKeymaps` — Reload `config/keymaps.lua`
- `:ReloadCommands` — Reload `config/commands.lua`

---

## Coding Conventions

- **Lua 5.1** (LuaJIT compatible)
- 2-space indentation, LF line endings
- Return a local `M` table pattern: `local M = {}; ...; return M`
- Module documentation uses `---@` type annotations (LuaLS / lazydev.nvim)
- Plugin specs use `---@type` annotations for config validation
- `vim.inspect` for debugging, occasionally `vim.print`
- Buffer-local keymaps use `buffer = event.buf` pattern
- Semicolons occasionally used as statement separators (not idiomatic Lua — author preference)

---

## Gotchas & Non-Obvious Patterns

1. **codeium_enabled is always false** in `plugins/blink.cmp.lua` line 16 despite workspace config support — if re-enabling Codeium, also uncomment the `zero.codeium` require in blink.cmp deps.
2. **blink.cmp and nvim-cmp** are mutually exclusive via `zero.enable_blink()` — editing the blink guard means also checking nvim-cmp's inverse guard.
3. **Godot autocmd** (`config/autocmds.lua`) runs on `VimEnter` and `DirChanged` — creates named pipes and batch files. Editing this affects Godot workflow on Windows.
4. **LSP binary paths** in `plugins/nvim-lspconfig.lua` are hardcoded to `$LOCALAPPDATA/nvim-data/mason/packages/...` — if you add a server, you must provide the explicit path.
5. **Logging** is gated by `vim.g.zerolog` — set this to `true` to enable file logging to `nryy.log`.
6. **Workspace config** file `.nnry-nvim.json` is project-specific — not committed to this repo, it's created per-project.
7. **queries/typescript/injections.scm** is an empty file — may be a placeholder.
8. **Lualine** uses `lsp-progress.nvim` for LSP progress display — tied to `LspProgressStatusUpdated` autocmd group.
9. **No GitHub Actions, no CI, no tests** in this repository.
10. **AutoIt LSP** path is hardcoded to a HOME directory path — may not exist on all machines.