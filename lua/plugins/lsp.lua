return {
  -- Mason for LSP server management
  {
    "williamboman/mason.nvim",
    enabled = not vim.g.vscode,
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    enabled = not vim.g.vscode,
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "lua_ls", "pyright", "ts_ls" },
    },
  },
  -- LSP progress indicator
  {
    "j-hui/fidget.nvim",
    enabled = not vim.g.vscode,
    opts = {},
  },
}
