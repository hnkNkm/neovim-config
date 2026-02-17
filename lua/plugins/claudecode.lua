-- Claude Code integration for Neovim
-- This plugin provides WebSocket-based MCP integration with Claude Code

return {
  "coder/claudecode.nvim",
  enabled = not vim.g.vscode, -- Disable in VSCode
  config = function()
    require("claudecode").setup({
      terminal_cmd = "/Users/hnk/.claude/local/claude",
      terminal = {  -- terminalはテーブルである必要がある
        provider = "native",  -- Use native terminal instead of snacks.nvim
      },
      log_level = "info",
    })
  end,
  -- Keymaps are now centralized in lua/config/keymaps.lua
}