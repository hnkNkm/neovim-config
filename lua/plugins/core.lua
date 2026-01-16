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
        transparent = true, -- Enable background transparency
        styles = {
          sidebars = "transparent", -- Style for sidebars
          floats = "transparent", -- Style for floating windows
        },
      })
     end,
   },
}
