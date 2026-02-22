local map = vim.keymap.set

-- Detect if running in VSCode
local in_vscode = vim.g.vscode

-- Set leader key to space (already set in init.lua)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic mappings

-- Save file with leader w
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })

-- Quit file with leader q (smart quit with buffer switching)
map("n", "<leader>q", function()
  local wins = vim.api.nvim_list_wins()
  local current_buf = vim.api.nvim_get_current_buf()
  local bufs = vim.api.nvim_list_bufs()
  local valid_bufs = {}
  
  -- Find all valid buffers (loaded and listed)
  for _, buf in ipairs(bufs) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      table.insert(valid_bufs, buf)
    end
  end
  
  -- If more than one window, just close the window
  if #wins > 1 then
    vim.cmd("q")
  -- If only one window and only one buffer, quit all
  elseif #valid_bufs <= 1 then
    vim.cmd("qa")
  -- If only one window but multiple buffers, switch buffer first then delete current
  else
    -- Store current buffer to delete it later
    local buf_to_delete = current_buf
    
    -- Try to switch to the next buffer
    vim.cmd("bnext")
    
    -- If we're still on the same buffer (means we were on the last buffer), go to previous
    if vim.api.nvim_get_current_buf() == buf_to_delete then
      vim.cmd("bprevious")
    end
    
    -- Now we should be on a different buffer, so delete the original one
    if vim.api.nvim_get_current_buf() ~= buf_to_delete then
      vim.api.nvim_buf_delete(buf_to_delete, { force = false })
    end
  end
end, { desc = "Smart quit: close window/buffer or quit all" })

-- Close current buffer (smart close - switch to next buffer first)
map("n", "<leader>x", function()
  local current_buf = vim.api.nvim_get_current_buf()
  local bufs = vim.api.nvim_list_bufs()
  local valid_bufs = {}
  
  -- Find all valid buffers (loaded and listed)
  for _, buf in ipairs(bufs) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      table.insert(valid_bufs, buf)
    end
  end
  
  -- If there's more than one buffer, switch to another before closing
  if #valid_bufs > 1 then
    -- Try to switch to the next or previous buffer
    vim.cmd("bn")
    -- If we're still on the same buffer (last buffer), go to previous
    if vim.api.nvim_get_current_buf() == current_buf then
      vim.cmd("bp")
    end
  end
  
  -- Now close the original buffer
  vim.api.nvim_buf_delete(current_buf, { force = false })
end, { desc = "Close current buffer (smart)" })

-- Buffer management (available in all environments)
map("n", "<leader>bb", ":bp<CR>", { desc = "Go to previous buffer" })
map("n", "<leader>bn", ":bn<CR>", { desc = "Go to next buffer" })
map("n", "<leader>bl", ":ls<CR>", { desc = "List buffers" })
map("n", "<Tab>", ":bn<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", ":bp<CR>", { desc = "Previous buffer" })
-- Alternative buffer navigation
map("n", "]b", ":bn<CR>", { desc = "Next buffer" })
map("n", "[b", ":bp<CR>", { desc = "Previous buffer" })

-- Clear search highlights
map("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
map("n", "<Esc>", ":nohl<CR>", { desc = "Clear search highlights" })

-- Consistent search navigation (n always forward, N always backward)
map("n", "n", "v:searchforward ? 'n' : 'N'", { expr = true, desc = "Next search result" })
map("n", "N", "v:searchforward ? 'N' : 'n'", { expr = true, desc = "Previous search result" })

-- Visual line movement (move selected lines up/down)
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Quick word replacement under cursor
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })

-- Center screen after navigation
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "n", "nzzzv", { desc = "Next search result centered" })
map("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- Window management (only in regular Neovim)
if not in_vscode then
  map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
  map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
  map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
  map("n", "<leader>sx", ":close<CR>", { desc = "Close current split" }) -- close current split window

  -- Tab management
  map("n", "<leader>to", ":tabnew<CR>", { desc = "Open new tab" }) -- open new tab
  map("n", "<leader>tx", ":tabclose<CR>", { desc = "Close current tab" }) -- close current tab

  -- Window navigation (Normal mode)
  map("n", "<C-h>", "<C-w>h", { desc = "Navigate to the left window" })
  map("n", "<C-j>", "<C-w>j", { desc = "Navigate to the bottom window" })
  map("n", "<C-k>", "<C-w>k", { desc = "Navigate to the top window" })
  map("n", "<C-l>", "<C-w>l", { desc = "Navigate to the right window" })
  
  -- Window navigation (Insert mode) - Commented out to avoid conflicts with Claude Code
  -- map("i", "<C-h>", "<Esc><C-w>h", { desc = "Navigate to the left window from insert" })
  -- map("i", "<C-j>", "<Esc><C-w>j", { desc = "Navigate to the bottom window from insert" })
  -- map("i", "<C-k>", "<Esc><C-w>k", { desc = "Navigate to the top window from insert" })
  -- map("i", "<C-l>", "<Esc><C-w>l", { desc = "Navigate to the right window from insert" })
  
  -- Window navigation (Terminal mode) - Removed to avoid conflicts with Claude Code
  -- These are now set conditionally in set_terminal_keymaps() function below
  
  -- Window resizing (leader + r prefix)
  map("n", "<leader>rh", ":vertical resize -5<CR>", { desc = "Decrease window width" })
  map("n", "<leader>rl", ":vertical resize +5<CR>", { desc = "Increase window width" })
  map("n", "<leader>rk", ":resize +5<CR>", { desc = "Increase window height" })
  map("n", "<leader>rj", ":resize -5<CR>", { desc = "Decrease window height" })
  
  -- Alternative: Use +/- for quick resizing
  map("n", "<leader>r+", ":vertical resize +10<CR>", { desc = "Increase width by 10" })
  map("n", "<leader>r-", ":vertical resize -10<CR>", { desc = "Decrease width by 10" })
  map("n", "<leader>r=", "<C-w>=", { desc = "Make all windows equal size" })
  
  -- Option to maximize current window
  map("n", "<leader>rm", "<C-w>|<C-w>_", { desc = "Maximize current window" })
  map("n", "<leader>rr", "<C-w>=", { desc = "Restore equal window sizes" })

  -- Terminal mode mappings are now handled by set_terminal_keymaps() function

  -- Git integration
  map("n", "<leader>gg", "<cmd>lua toggle_lazygit()<CR>", { desc = "Open lazygit" })
  -- Alternative: open lazygit in a new tab
  map("n", "<leader>gG", ":tabnew | terminal lazygit<CR>", { desc = "Open lazygit in new tab" })
end

-- Plugin Keymaps (only in regular Neovim)
if not in_vscode then
  -- Telescope (Fuzzy Finder) - 2025 best practices
  map("n", "<leader>ff", function()
    local builtin = require("telescope.builtin")
    local ok = pcall(builtin.git_files, {})
    if not ok then
      builtin.find_files({})
    end
  end, { desc = "Find files (git-aware)" })
  map("n", "<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>", { desc = "Find all files" })
  map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Find old files" })
  map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
  map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Find help tags" })
  map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
  map("n", "<leader>fw", "<cmd>Telescope grep_string<CR>", { desc = "Find word under cursor" })
  map("n", "<leader>fc", "<cmd>Telescope colorscheme enable_preview=true<CR>", { desc = "Find colorscheme" })
  map("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find todos in project" })
  
  -- Git (Telescope)
  map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git commits" })
  map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Git status" })
  
  -- LSP (Telescope)
  map("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Document symbols" })
  map("n", "<leader>lr", "<cmd>Telescope lsp_references<CR>", { desc = "References" })
  map("n", "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Document diagnostics" })
  map("n", "<leader>lD", "<cmd>Telescope diagnostics<CR>", { desc = "Workspace diagnostics" })
  
  -- nvim-tree (File Explorer)
  map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
  map("n", "<C-n>", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer (alt)" })
  map("n", "<C-t>", ":NvimTreeFocus<CR>", { desc = "Focus file tree" })
  map("n", "<C-f>", ":NvimTreeFindFile<CR>", { desc = "Find current file in tree" })
  
  -- ToggleTerm (Terminal) - Each with unique ID for independent instances
  map("n", "<leader>tt", "<cmd>1ToggleTerm<CR>", { desc = "Toggle terminal (default)" })
  map("n", "<leader>tf", "<cmd>2ToggleTerm direction=float<CR>", { desc = "Toggle floating terminal" })
  map("n", "<leader>th", "<cmd>3ToggleTerm direction=horizontal<CR>", { desc = "Toggle horizontal terminal" })
  map("n", "<leader>tv", "<cmd>4ToggleTerm direction=vertical<CR>", { desc = "Toggle vertical terminal" })
  map("n", "<leader>ts", "<cmd>5ToggleTerm size=15 direction=horizontal<CR>", { desc = "Toggle small terminal below" })
  map("n", "<leader>tT", "<cmd>6ToggleTerm direction=tab<CR>", { desc = "Toggle terminal in new tab" })
  
  -- REPL keymaps (requires functions to be defined)
  map("n", "<leader>tg", "<cmd>lua toggle_lazygit()<CR>", { desc = "Toggle Lazygit" })
  map("n", "<leader>tn", "<cmd>lua toggle_node()<CR>", { desc = "Toggle Node REPL" })
  map("n", "<leader>tp", "<cmd>lua toggle_python()<CR>", { desc = "Toggle Python REPL" })
  
  -- Formatting
  map("n", "<leader>lf", function()
    vim.lsp.buf.format({ async = true })
  end, { desc = "Format document" })
  
  -- Todo Comments Navigation
  map("n", "]t", function()
    require("todo-comments").jump_next()
  end, { desc = "Next todo comment" })
  map("n", "[t", function()
    require("todo-comments").jump_prev()
  end, { desc = "Previous todo comment" })
  
  -- Notify (nvim-notify)
  map("n", "<leader>nd", function()
    require("notify").dismiss({ silent = true, pending = true })
  end, { desc = "Dismiss all notifications" })
  
  -- Bufferline
  map("n", "<leader>bp", "<cmd>BufferLinePick<CR>", { desc = "Pick buffer" })
  map("n", "<leader>bc", "<cmd>BufferLinePickClose<CR>", { desc = "Pick buffer to close" })
  map("n", "<leader>bP", "<cmd>BufferLineTogglePin<CR>", { desc = "Toggle buffer pin" })
  map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
  map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
  map("n", "<leader>br", "<cmd>BufferLineCloseRight<CR>", { desc = "Close buffers to the right" })
  map("n", "<leader>bL", "<cmd>BufferLineCloseLeft<CR>", { desc = "Close buffers to the left" })
  
  -- Session Management (persistence.nvim)
  map("n", "<leader>qs", function()
    require("persistence").load()
  end, { desc = "Restore session for current directory" })
  map("n", "<leader>ql", function()
    require("persistence").load({ last = true })
  end, { desc = "Restore last session" })
  map("n", "<leader>qd", function()
    require("persistence").stop()
  end, { desc = "Stop session persistence" })
  
  -- Claude Code Integration
  map("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude Code" })
  map("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus/Toggle Claude Code" })
  map("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send selection to Claude" })
  map("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept Claude's changes" })
  map("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Reject Claude's changes" })
  
  -- Gitsigns (lazy-loaded, so wrapped in pcall)
  local ok, gs = pcall(require, "gitsigns")
  if ok then
    -- Navigation
    map("n", "]h", function()
      if vim.wo.diff then return "]h" end
      vim.schedule(function() gs.next_hunk() end)
      return "<Ignore>"
    end, { expr = true, desc = "Next Hunk" })
    
    map("n", "[h", function()
      if vim.wo.diff then return "[h" end
      vim.schedule(function() gs.prev_hunk() end)
      return "<Ignore>"
    end, { expr = true, desc = "Prev Hunk" })
    
    -- Alternative navigation (vim-gitgutter compatible)
    map("n", "]c", function() gs.next_hunk() end, { desc = "Next Hunk (gitgutter)" })
    map("n", "[c", function() gs.prev_hunk() end, { desc = "Prev Hunk (gitgutter)" })
    
    -- Actions
    map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage Hunk" })
    map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset Hunk" })
    map("v", "<leader>hs", function()
      gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Stage Hunk" })
    map("v", "<leader>hr", function()
      gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Reset Hunk" })
    map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage Buffer" })
    map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
    map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset Buffer" })
    map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview Hunk" })
    map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "Blame Line" })
    map("n", "<leader>hd", gs.diffthis, { desc = "Diff This" })
    map("n", "<leader>hD", function() gs.diffthis("~") end, { desc = "Diff This ~" })
    
    -- Toggles
    map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle Blame Line" })
    map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle Deleted" })
    map("n", "<leader>uG", gs.toggle_signs, { desc = "Toggle Git Signs" })
    
    -- Text object
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk" })
  end
end

-- Help (available in both VSCode and regular Neovim)
map("n", "<leader>hh", ":help<CR>", { desc = "Open help" })
map("n", "<leader>hm", ":help index<CR>", { desc = "Help index (all commands)" })
map("n", "<leader>hk", ":help keycodes<CR>", { desc = "Help keycodes" })
map("n", "<leader>ht", ":help tips<CR>", { desc = "Vim tips" })
map("n", "<leader>ho", ":help options<CR>", { desc = "Vim options" })
map("n", "<leader>ha", ":help autocmd-events<CR>", { desc = "Autocmd events" })
map("n", "<leader>hf", ":help function-list<CR>", { desc = "Vim functions" })
map("n", "<leader>hs", ":Telescope help_tags<CR>", { desc = "Search help tags" })

-- Visual feedback when yanking text (2025 best practice)
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlights text when yanking",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- LSP Keymaps (attached when LSP is active)
-- Set up via autocmd to apply only to buffers with LSP attached
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
  callback = function(ev)
    local function opts(desc)
      return { buffer = ev.buf, desc = "LSP: " .. desc }
    end
    
    -- Navigation (Core LSP keymaps - 2025 best practices)
    map("n", "gD", vim.lsp.buf.declaration, opts("Go to Declaration"))
    map("n", "gd", vim.lsp.buf.definition, opts("Go to Definition"))
    map("n", "gi", vim.lsp.buf.implementation, opts("Go to Implementation"))
    map("n", "go", vim.lsp.buf.type_definition, opts("Go to Type Definition"))
    map("n", "gr", vim.lsp.buf.references, opts("Show References"))
    
    -- Documentation and Info
    map("n", "K", vim.lsp.buf.hover, opts("Hover Documentation"))
    map("n", "<leader>k", vim.lsp.buf.hover, opts("Hover Documentation (alt)"))
    map("n", "<leader>K", vim.lsp.buf.signature_help, opts("Signature Help"))
    -- Removed Insert mode <C-k> to avoid conflicts with Claude Code
    
    -- Code Actions and Refactoring
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Code Action"))
    map({ "n", "v" }, "gra", vim.lsp.buf.code_action, opts("Code Action (alt)"))
    map("n", "<leader>cr", vim.lsp.buf.rename, opts("Rename Symbol"))
    map("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename Symbol (alt)"))
    
    -- Formatting
    map("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts("Format Document"))
    
    -- Workspace folders
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Add Workspace Folder"))
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove Workspace Folder"))
    map("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts("List Workspace Folders"))
    
    -- Diagnostics navigation
    map("n", "[d", vim.diagnostic.goto_prev, opts("Previous Diagnostic"))
    map("n", "]d", vim.diagnostic.goto_next, opts("Next Diagnostic"))
    map("n", "<leader>d", vim.diagnostic.open_float, opts("Show Line Diagnostics"))
    map("n", "<leader>lq", vim.diagnostic.setloclist, opts("Diagnostics to Quickfix"))
  end,
})

-- K shows help for word under cursor only when LSP is not attached
-- In VSCode, let VSCode handle hover
if not in_vscode then
  map("n", "K", function()
    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
    if #clients == 0 then
      local word = vim.fn.expand("<cword>")
      if word ~= "" then
        vim.cmd("help " .. word)
      end
    else
      vim.lsp.buf.hover()
    end
  end, { desc = "Show hover info or help for word under cursor" })
end

-- ToggleTerm Terminal Mode Keymaps (2025 recommended)
-- Set up terminal-specific keymaps when a terminal opens
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  
  -- Get the current buffer name to detect Claude Code
  local bufname = vim.api.nvim_buf_get_name(0)
  local is_claude = bufname:match("claude") ~= nil
  
  -- Terminal escape keymaps
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-]>', [[<C-\><C-n>]], opts)
  
  -- Only set navigation keymaps if not in Claude Code terminal
  -- This prevents conflicts with Claude's input handling
  if not is_claude then
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
  end
end

-- Auto-set keymaps when terminal opens
vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')
