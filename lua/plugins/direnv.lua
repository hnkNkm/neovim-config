return {
  -- direnv integration for project-specific environments
  -- Must load early, before LSP plugins that depend on direnv environment
  {
    "NotAShelf/direnv.nvim",
    enabled = not vim.g.vscode,
    lazy = false, -- Load early
    priority = 1000, -- High priority to load before other plugins
    opts = {
      autoload_direnv = true,
      statusline = {
        enabled = true,
      },
      keybindings = {
        allow = "<Leader>da",
        deny = "<Leader>dd",
        reload = "<Leader>dr",
      },
    },
  },
}
