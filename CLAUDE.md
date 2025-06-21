# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a VSCode-compatible Neovim configuration that uses lazy.nvim for plugin management. The configuration intelligently detects whether it's running in VSCode or standalone Neovim and adjusts features accordingly.

## Architecture

The configuration follows a modular structure:
- `init.lua` - Entry point that bootstraps lazy.nvim and loads all configuration
- `lua/config/` - Core Neovim settings (options, keymaps, filetypes)
- `lua/plugins/` - Individual plugin configurations, each returning a plugin spec table
- `lazy-lock.json` - Locked plugin versions for reproducibility

Key architectural decisions:
- All plugins check `vim.g.vscode` to determine VSCode compatibility
- Plugin configurations are isolated in separate files for maintainability
- Leader key is set to space for all environments

## Commands

### Plugin Management
```bash
# Update plugins (in Neovim)
:Lazy sync

# Check plugin status
:Lazy

# Clean unused plugins
:Lazy clean
```

### LSP and Formatting
- LSP servers are automatically installed via Mason when opening relevant files
- Format current buffer: `<leader>f` (standalone Neovim only)
- LSP actions are bound to standard keys (gd, K, etc.) in standalone mode

### Development Workflow
Since this is a Neovim configuration, there's no traditional build/test system. When modifying:
1. Test changes by restarting Neovim or running `:source %` on the changed file
2. Use `:Lazy reload <plugin-name>` to reload specific plugins
3. Check `:messages` and `:LspInfo` for debugging

## Custom Claude Plugin

There's a custom Claude AI integration plugin at `lua/plugins/claude.lua` that references a local development plugin at `~/programs/lua/nvim-myplugin/`. When working with this:
- The plugin provides AI-powered code assistance within Neovim
- API keys should be stored in environment variables, not in the source code
- Test the plugin using the test file at `~/programs/lua/nvim-myplugin/tests/claude_test.lua`

## VSCode Compatibility

The configuration maintains compatibility by:
- Disabling UI-heavy plugins when `vim.g.vscode` is true
- Preserving essential mappings that work in both environments
- Using conditional plugin loading with `enabled = not vim.g.vscode`

## Important Files

- `README.md` - Comprehensive user documentation and key mappings
- `lua/plugins/lsp.lua` - Language server configurations
- `lua/plugins/formatting.lua` - Code formatting setup (currently has linters disabled)
- `lua/config/keymaps.lua` - All custom key mappings with VSCode checks