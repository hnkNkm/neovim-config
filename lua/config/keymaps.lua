local map = vim.keymap.set

-- Detect if running in VSCode
local in_vscode = vim.g.vscode

-- Basic mappings
-- Use jk to exit insert mode
map("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- Save file with leader w
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })

-- Quit file with leader q
map("n", "<leader>q", function()
  if #vim.api.nvim_list_wins() > 1 then
    vim.cmd("q")
  else
    vim.cmd("qa")
  end
end, { desc = "Smart quit: close window or quit all" })

-- Close current buffer
map("n", "<leader>x", ":bd<CR>", { desc = "Close current buffer" })


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
  map("n", "<leader>tn", ":tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
  map("n", "<leader>tp", ":tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab

  -- Window navigation
  map("n", "<C-h>", "<C-w>h", { desc = "Navigate to the left window" })
  map("n", "<C-j>", "<C-w>j", { desc = "Navigate to the bottom window" })
  map("n", "<C-k>", "<C-w>k", { desc = "Navigate to the top window" })
  map("n", "<C-l>", "<C-w>l", { desc = "Navigate to the right window" })
  
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

  -- Terminal (open relative to current window)
  map("n", "<leader>tt", ":terminal<CR>", { desc = "Open terminal in new buffer" })
  map("n", "<leader>tl", ":rightbelow vsplit | terminal<CR>", { desc = "Open terminal to the right" })
  map("n", "<leader>th", ":leftabove vsplit | terminal<CR>", { desc = "Open terminal to the left" })
  map("n", "<leader>tj", ":rightbelow split | terminal<CR>", { desc = "Open terminal below" })
  map("n", "<leader>tk", ":leftabove split | terminal<CR>", { desc = "Open terminal above" })
  
  -- Quick terminal toggles for common positions
  map("n", "<leader>tv", ":rightbelow vsplit | terminal<CR>", { desc = "Terminal right (vertical)" })
  map("n", "<leader>ts", ":rightbelow split | terminal<CR>", { desc = "Terminal below (horizontal)" })
  
  map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" }) -- Use Esc to exit terminal mode
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
