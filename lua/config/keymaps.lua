local map = vim.keymap.set

-- Detect if running in VSCode
local in_vscode = vim.g.vscode

-- Basic mappings
-- Use jk to exit insert mode
map("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

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
  
  -- Window navigation (Insert mode) - Claude Code実行中でも移動可能
  map("i", "<C-h>", "<Esc><C-w>h", { desc = "Navigate to the left window from insert" })
  map("i", "<C-j>", "<Esc><C-w>j", { desc = "Navigate to the bottom window from insert" })
  map("i", "<C-k>", "<Esc><C-w>k", { desc = "Navigate to the top window from insert" })
  map("i", "<C-l>", "<Esc><C-w>l", { desc = "Navigate to the right window from insert" })
  
  -- Window navigation (Terminal mode) - Claude Code実行中でも移動可能
  map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Navigate to the left window from terminal" })
  map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Navigate to the bottom window from terminal" })
  map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Navigate to the top window from terminal" })
  map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Navigate to the right window from terminal" })
  
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

  -- Terminal mode mapping: Double Esc/C-] to exit, single press sends to terminal
  local last_esc_time = 0
  local function handle_terminal_escape()
    local current_time = vim.loop.now()
    if current_time - last_esc_time < 300 then  -- 300ms以内に2回押したら抜ける
      last_esc_time = 0
      return "<C-\\><C-n>"
    else
      last_esc_time = current_time
      return "<Esc>"
    end
  end
  map("t", "<Esc>", handle_terminal_escape, { expr = true, desc = "Double Esc to exit terminal mode" })
  map("t", "<C-]>", handle_terminal_escape, { expr = true, desc = "Double C-] to exit terminal mode" })

  -- Git integration
  map("n", "<leader>gg", "<cmd>lua toggle_lazygit()<CR>", { desc = "Open lazygit" })
  -- Alternative: open lazygit in a new tab
  map("n", "<leader>gG", ":tabnew | terminal lazygit<CR>", { desc = "Open lazygit in new tab" })
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
