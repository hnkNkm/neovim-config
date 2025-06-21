-- Claude Code integration for Neovim
-- This plugin provides WebSocket-based MCP integration with Claude Code

return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  enabled = not vim.g.vscode, -- Disable in VSCode
  config = true,
  opts = {
    -- Claude Code CLIの実際のパスを指定
    terminal_cmd = "/Users/hnk/.claude/local/claude",
    log_level = "info", -- 通常のログレベル
  },
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus/Toggle Claude Code" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude's changes" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject Claude's changes" }
  }
}