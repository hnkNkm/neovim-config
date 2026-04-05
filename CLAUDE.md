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
lua/plugins/
  *.lua                  # Each file returns a lazy.nvim plugin spec table
```

Key patterns:
- Plugins use `enabled = not vim.g.vscode` to disable in VSCode
- LSP keymaps are set in `LspAttach` autocmd (lua/plugins/lsp.lua:80-111)
- Terminal integration uses toggleterm with custom REPL functions (lua/plugins/terminal.lua)

## Commands

```vim
:Lazy sync              " Update all plugins
:Lazy reload <name>     " Reload specific plugin
:source %               " Reload current Lua file
:messages               " Check for errors
:LspInfo                " Debug LSP connections
:Mason                  " Manage LSP servers
```

## Mason Configuration

Mason and mason-lspconfig.nvim are now properly configured:
- Uses Neovim 0.11+'s native `vim.lsp.config()` API
- Automatic installation via `ensure_installed` in mason-lspconfig
- Automatic enabling of Mason-installed servers with `automatic_enable = true`
- LSP servers configured: lua_ls, pyright, ts_ls, html, cssls, jsonls

## Claude Code Integration

The `claudecode.nvim` plugin (lua/plugins/claudecode.lua) provides MCP integration:
- `<leader>ac` toggles Claude Code terminal
- `<leader>as` sends visual selection to Claude
- Uses local Claude CLI at `/Users/hnk/.claude/local/claude`