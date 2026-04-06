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
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "refractalize/oil-git-status.nvim",
    },
    opts = {
      default_file_explorer = true,
      columns = { "icon" },
      view_options = {
        show_hidden = false,
      },
      win_options = {
        signcolumn = "yes:2",
      },
    },
  },

  -- Git status for oil.nvim
  {
    "refractalize/oil-git-status.nvim",
    enabled = not vim.g.vscode,
    dependencies = { "stevearc/oil.nvim" },
    opts = {},
  },
}
