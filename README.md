# VSCode Compatible Neovim Configuration

A modern Neovim configuration that works seamlessly in both standalone Neovim and VSCode Neovim extension.

## Features

- **Plugin Management**: Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for efficient plugin management
- **VSCode Compatibility**: Automatically detects and adapts when running inside VSCode
- **Modern UI**: Beautiful interface with Tokyo Night theme, status line, and file explorer (in standalone mode)
- **LSP Support**: Integrated Language Server Protocol for code intelligence (in standalone mode)
- **Autocompletion**: Smart code completion with nvim-cmp (in standalone mode)
- **Syntax Highlighting**: Enhanced syntax highlighting with Treesitter
- **Terminal Integration**: Floating terminal and REPL support (in standalone mode)
- **File Navigation**: Fuzzy finding with Telescope (limited functionality in VSCode)
- **Git Integration**: Git commands and status display (in standalone mode)
- **Session Management**: Automatic session saving and restoration (in standalone mode)

## Included Plugins

### Core Plugins (Both Modes)

- **Comment.nvim**: Easy code commenting
- **nvim-autopairs**: Automatic bracket pairing
- **todo-comments.nvim**: Highlight and search TODO comments

### Standalone Neovim Only

- **tokyonight.nvim**: Modern colorscheme
- **lualine.nvim**: Enhanced status line
- **nvim-tree.lua**: File explorer
- **nvim-lspconfig**: LSP configuration
- **mason.nvim**: LSP server management
- **nvim-cmp**: Completion engine
- **none-ls.nvim**: Formatting and linting
- **toggleterm.nvim**: Terminal management
- **persistence.nvim**: Session management
- **telescope.nvim**: Fuzzy finder
- **bufferline.nvim**: Buffer management
- **nvim-notify**: Notification system

## Installation

### Prerequisites

- Neovim 0.8.0 or later
- Git
- (Optional) Node.js for LSP features
- (Optional) Ripgrep for Telescope search

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

- Leader key: `<Space>`
- Exit insert mode: `jk`
- Toggle file explorer: `<leader>e` (standalone only)
- Find files: `<leader>ff` (standalone only)
- Find text: `<leader>fg` (standalone only)
- Open terminal: `<leader>t` (standalone only)
- Comment line: `gcc`
- Comment selection: `gc` (in visual mode)
- Help: `<leader>h`

## Customization

- Edit files in `lua/config/` to modify basic settings
- Edit files in `lua/plugins/` to modify plugin configurations
- Add new plugins by creating new files in `lua/plugins/`

## License

MIT
