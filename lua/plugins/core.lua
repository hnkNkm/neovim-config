return {
  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- Load the colorscheme here.
      -- vim.cmd([[colorscheme tokyonight]]) -- Already set in init.lua, but good practice to have config block
      require("tokyonight").setup({
        style = "storm", -- You can change this to "night", "moon", or "day"
         -- For more configuration options, see the plugin's documentation
       })
     end,
   },
}
