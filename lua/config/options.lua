-- Set options
local opt = vim.opt

opt.number = true -- Show line numbers
opt.relativenumber = false -- Show only absolute line numbers
opt.cursorline = true -- Highlight the current line
opt.termguicolors = true -- Enable true color support
opt.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for
opt.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent
opt.expandtab = true -- Use spaces instead of tabs
opt.autoindent = true -- Copy indent from current line when starting a new line
opt.wrap = false -- Do not wrap lines
opt.ignorecase = true -- Ignore case in search patterns
opt.smartcase = true -- Override ignorecase if pattern contains uppercase letters
opt.hlsearch = true -- Highlight all matches on search
opt.incsearch = true -- Show search results incrementally
opt.scrolloff = 8 -- Minimum number of screen lines to keep above and below the cursor
opt.sidescrolloff = 8 -- Minimum number of screen columns to keep to the left and right of the cursor
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.completeopt = "menuone,noselect" -- Set completion options
opt.updatetime = 300 -- Faster completion (default is 4000ms)
opt.signcolumn = "yes" -- Always show the sign column

-- Auto reload files when changed outside of Neovim
opt.autoread = true -- Automatically read file when changed outside of Neovim

-- Auto reload trigger on focus/buffer switch (less aggressive)
vim.api.nvim_create_autocmd({"FocusGained", "BufEnter"}, {
  pattern = "*",
  callback = function()
    -- Only check if not in command mode and not in special buffers
    local buftype = vim.bo.buftype
    if vim.fn.mode() ~= 'c' and buftype == "" then
      vim.cmd("checktime")
    end
  end,
})

-- Notification when file changes (only for actual file changes)
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    -- Only notify for actual files, not special buffers
    if vim.bo.buftype == "" then
      vim.notify("File reloaded from disk", vim.log.levels.INFO)
    end
  end,
})

-- Help window settings
opt.helpheight = 12 -- Minimum height of help window
opt.helplang = "en" -- Set help language to English
