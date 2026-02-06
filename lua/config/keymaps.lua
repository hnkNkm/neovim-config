local map = vim.keymap.set

-- Detect if running in VSCode
local in_vscode = vim.g.vscode

-- Basic mappings
-- Use jk to exit insert mode
map("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- Save file with leader w
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })

-- Quit file with leader q
map("n", "<leader>q", ":q<CR>", { desc = "Quit window" })

-- Close current buffer
map("n", "<leader>x", ":Bdelete<CR>", { desc = "Close current buffer" })

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
  
  -- Window resizing
  map("n", "<leader>r=", "<C-w>=", { desc = "Make windows equal size" })
  map("n", "<leader>rm", "<C-w>|<C-w>_", { desc = "Maximize current window" })
  -- Direct size input
  map("n", "<leader>rs", ":vertical resize ", { desc = "Set window width (type number)" })
  map("n", "<leader>rh", ":resize ", { desc = "Set window height (type number)" })

  -- Terminal mode mapping: simple exit
  map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

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
