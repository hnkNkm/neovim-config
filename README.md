# VSCode Compatible Neovim Configuration

A modern Neovim configuration that works seamlessly in both standalone Neovim and VSCode Neovim extension.

## Features

- **Plugin Management**: Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for efficient plugin management
- **VSCode Compatibility**: Automatically detects and adapts when running inside VSCode
- **Modern UI**: Beautiful interface with Tokyo Night theme, status line, and file explorer (in standalone mode)
- **LSP Support**: Neovim 0.11+ compatible with new `vim.lsp.config` API (in standalone mode)
- **Autocompletion**: Smart code completion with nvim-cmp (in standalone mode)
- **Syntax Highlighting**: Enhanced syntax highlighting with Treesitter
- **Terminal Integration**: ToggleTerm with floating terminal and REPL support (in standalone mode)
- **File Navigation**: Fuzzy finding with Telescope (limited functionality in VSCode)
- **Git Integration**: Lazygit and Gitsigns for comprehensive Git support (in standalone mode)
- **Session Management**: Automatic session saving and restoration with Persistence (in standalone mode)
- **Japanese Input**: SKKeleton integration for native Japanese input support
- **Claude Code Integration**: AI assistant integration via claudecode.nvim (in standalone mode)

## Included Plugins

### Core Plugins (Both Modes)

- **Comment.nvim**: Easy code commenting
- **nvim-autopairs**: Automatic bracket pairing
- **todo-comments.nvim**: Highlight and search TODO comments

### Standalone Neovim Only

- **tokyonight.nvim**: Modern colorscheme with transparency support
- **lualine.nvim**: Enhanced status line
- **nvim-tree.lua**: File explorer with Git integration
- **nvim-lspconfig**: LSP configuration (Neovim 0.11+ compatible)
- **mason.nvim**: LSP server management
- **nvim-cmp**: Completion engine
- **none-ls.nvim**: Formatting and linting
- **toggleterm.nvim**: Terminal management with REPL support
- **persistence.nvim**: Session management
- **telescope.nvim**: Fuzzy finder
- **bufferline.nvim**: Buffer management
- **nvim-notify**: Notification system
- **gitsigns.nvim**: Git integration in buffers
- **vim-skk/skkeleton**: Japanese input method
- **vim-denops/denops.vim**: Deno plugin framework for SKKeleton
- **claudecode.nvim**: Claude AI assistant integration

## Installation

### Prerequisites

- Neovim 0.11.3 or later (0.11.4+ recommended)
- Git
- (Optional) Node.js for LSP features
- (Optional) Ripgrep for Telescope search
- (Optional) Deno for SKKeleton (Japanese input)
- (Optional) SKK dictionaries for Japanese input

### Setup

1. Clone this repository to your Neovim configuration directory:

   ```bash
   git clone https://github.com/hnkNkm/neovim-config.git ~/.config/nvim
   ```

2. Start Neovim:

   ```bash
   nvim
   ```

3. The configuration will automatically install lazy.nvim and all plugins on first launch.

### VSCode Setup

1. Install the [VSCode Neovim extension](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim)
2. Clone this repository to your Neovim configuration directory
3. Configure the extension to use your Neovim executable

## Key Mappings

See [neovim-cheatsheet.md](./neovim-cheatsheet.md) for complete key mapping reference.

### Essential Mappings

- **Leader key**: `<Space>`
- **Exit insert mode**: `jk` or `ESC`
- **Save file**: `<leader>w`
- **Smart quit**: `<leader>q`
- **Smart buffer close**: `<leader>x`

### Navigation

- **File explorer**: `<leader>e`
- **Find files**: `<leader>ff` (Git-aware)
- **Live grep**: `<leader>fg`
- **Buffer navigation**: `Tab`/`Shift-Tab`
- **Window navigation**: `Ctrl-h/j/k/l`

### Features

- **Terminal**: `<leader>tt` (floating)
- **Lazygit**: `<leader>gg`
- **Comment line**: `gcc`
- **Japanese input**: `Ctrl-l` (insert mode)
- **Claude Code**: `<leader>ac`
- **LSP hover**: `K`
- **Code action**: `<leader>ca`

## Customization

### Configuration Structure

```
lua/
├── config/
│   ├── options.lua    # Vim options and settings
│   ├── keymaps.lua    # Centralized key mappings
│   └── filetypes.lua  # Filetype-specific settings
└── plugins/
    ├── ui.lua         # UI plugins (lualine, nvim-tree)
    ├── editor.lua     # Editor enhancements
    ├── lsp.lua        # LSP configuration
    ├── formatting.lua # Formatters and linters
    └── ...            # Other plugin configurations
```

### Adding Custom Settings

- **Vim options**: Edit `lua/config/options.lua`
- **Key mappings**: Edit `lua/config/keymaps.lua` (all mappings are centralized here)
- **New plugins**: Create a new file in `lua/plugins/` returning a plugin spec

### Project-Specific Instructions

Create a `CLAUDE.md` file in your project root to provide Claude Code with project-specific instructions and context.

## License

MIT
