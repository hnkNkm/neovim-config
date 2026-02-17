return {
  -- Session management (only load in regular Neovim, not in VSCode)
  {
    "folke/persistence.nvim",
    enabled = not vim.g.vscode,
    event = "BufReadPre",
    config = function()
      require("persistence").setup({
        dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"), -- directory where session files are saved
        options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" }, -- sessionoptions used for saving
        pre_save = nil, -- a function to call before saving the session
        save_empty = false, -- don't save if there are no open file buffers
      })

      -- Keymaps are now centralized in lua/config/keymaps.lua
    end,
  },
}
