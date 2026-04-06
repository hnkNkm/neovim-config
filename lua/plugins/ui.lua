return {
  -- Status line (only load in regular Neovim, not in VSCode)
  {
    "nvim-lualine/lualine.nvim",
    enabled = not vim.g.vscode,
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional: for icons
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight", -- Use theme from colorscheme plugin
           -- See lualine documentation for more options
         },
       })
     end,
   },

  -- File explorer (oil.nvim - edit filesystem like a buffer)
  {
    "stevearc/oil.nvim",
    enabled = not vim.g.vscode,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        columns = { "icon" },
        view_options = {
          show_hidden = false,
        },
        win_options = {
          signcolumn = "yes:2",
        },
      })
      -- Setup git status after oil is configured
      require("oil-git-status").setup({})
    end,
  },

  -- Git status for oil.nvim (loaded by oil.nvim config)
  {
    "refractalize/oil-git-status.nvim",
    enabled = not vim.g.vscode,
    lazy = true,
  },
}
