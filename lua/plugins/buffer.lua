return {
  -- Better buffer deletion (doesn't mess up window layout)
  {
    "famiu/bufdelete.nvim",
    enabled = not vim.g.vscode,
    cmd = { "Bdelete", "Bwipeout" },
  },
}
