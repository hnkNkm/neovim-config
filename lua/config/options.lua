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

-- Window split behavior
opt.splitright = true -- Open vertical splits to the right
opt.splitbelow = true -- Open horizontal splits below

-- Help window settings
opt.helpheight = 12 -- Minimum height of help window
opt.helplang = "en" -- Set help language to English
