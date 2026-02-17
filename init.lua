-- Detect if running in VSCode Neovim
vim.g.vscode = vim.fn.exists('g:vscode') == 1

-- Set leader key to space (must be set before lazy.nvim)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Import plugin specifications from lua/plugins directory
    { import = "plugins" },
  },
  -- Configure lazy.nvim options
  install = {
    colorscheme = { "tokyonight" }, -- Set colorscheme after install
  },
  checker = {
    enabled = true, -- Check for plugin updates
    notify = false, -- Don't notify on updates
  },
  change_detection = {
    enabled = true,
    notify = false, -- Don't notify on config changes
  },
})

-- Load basic configurations
require("config.options")
require("config.keymaps")
require("config.filetypes")

-- Set colorscheme (only in regular Neovim, not in VSCode)
if not vim.g.vscode then
  vim.cmd([[colorscheme tokyonight]])
  
  -- Always ensure an empty buffer exists at startup
  -- This prevents files from opening in terminal windows
  vim.cmd("enew")
end
