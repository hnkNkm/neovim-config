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

  -- File explorer (only load in regular Neovim, not in VSCode)
  {
    "nvim-tree/nvim-tree.lua",
    enabled = not vim.g.vscode,
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional: for icons
    config = function()
      require("nvim-tree").setup({
        -- See nvim-tree documentation for more options
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
         },
       })

       -- Keymaps for nvim-tree
      local map = vim.keymap.set
      map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    end,
  },
}
