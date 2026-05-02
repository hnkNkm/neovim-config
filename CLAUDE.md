# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

VSCode-compatible Neovim configuration using lazy.nvim. Detects `vim.g.vscode` to conditionally load plugins and keymaps.

## Architecture

```
init.lua                 # Bootstraps lazy.nvim, loads config modules, sets colorscheme
lua/config/
  options.lua            # Vim options (tabs, search, clipboard, etc.)
  keymaps.lua            # All keymaps with VSCode conditional logic
  filetypes.lua          # Filetype-specific settings
  lsp.lua                # LSP setup: diagnostic config, capabilities, vim.lsp.enable()
lua/plugins/
  *.lua                  # Each file returns a lazy.nvim plugin spec table
lsp/
  <server>.lua           # Per-server config (cmd, filetypes, root_markers, settings)
                         # Auto-loaded by Neovim 0.12 via runtimepath convention
```

Key patterns:
- Plugins use `enabled = not vim.g.vscode` to disable in VSCode
- Terminal integration uses toggleterm with custom REPL functions (lua/plugins/terminal.lua)
- `lua/config/lsp.lua` gates each server behind `vim.fn.executable()` — servers activate
  only when their binary is on PATH (typically supplied by direnv-loaded Nix env)

## Commands

```vim
:Lazy sync              " Update all plugins
:Lazy reload <name>     " Reload specific plugin
:source %               " Reload current Lua file
:messages               " Check for errors
:checkhealth vim.lsp    " LSP health
:LspInfo                " Show attached LSP clients
:LspLog                 " LSP log
```

## LSP Configuration (Neovim 0.12 native)

No Mason, no nvim-lspconfig. Uses the built-in `vim.lsp.config()` / `vim.lsp.enable()`
API with per-server files under `lsp/*.lua`.

- LSP server binaries are provided by Nix:
  1. **Per-project**: `flake.nix` + direnv in the project directory (picked up by
     `direnv.nvim` at startup, adding the Nix store paths to `$PATH`)
  2. **Global**: home-manager packages
- `lua/config/lsp.lua` holds a `server_cmds` table mapping server-name → executable;
  only servers whose executable is found on PATH are enabled.
- blink.cmp supplies LSP capabilities to each enabled server.
- Currently wired servers: lua_ls, ts_ls, pyright, nil_ls, gopls, zls, jsonls,
  rust_analyzer, denols, elixirls.

To add a new LSP server:
1. Add an entry to `server_cmds` in `lua/config/lsp.lua`
2. Create `lsp/<server>.lua` returning `{ cmd, filetypes, root_markers, settings }`
3. Ensure the binary is available via Nix (project `flake.nix` or home-manager)

## Claude Code Integration

The `claudecode.nvim` plugin (lua/plugins/claudecode.lua) provides MCP integration:
- `<leader>ac` toggles Claude Code terminal
- `<leader>as` sends visual selection to Claude
- Uses local Claude CLI at `/Users/hnk/.claude/local/claude`