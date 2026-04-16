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

-- Notification when file changes and refresh LSP
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    -- Only for actual files, not special buffers
    if vim.bo.buftype == "" then
      vim.notify("File reloaded from disk", vim.log.levels.INFO)
      -- Force LSP to re-sync by editing nothing (triggers didChange)
      vim.schedule(function()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        if #clients > 0 then
          -- Notify LSP of buffer change
          for _, client in ipairs(clients) do
            local params = {
              textDocument = {
                uri = vim.uri_from_bufnr(bufnr),
                version = vim.lsp.util.buf_versions[bufnr] or 0,
              },
              contentChanges = {
                { text = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n") }
              },
            }
            client:notify("textDocument/didChange", params)
          end
        end
      end)
    end
  end,
})

-- More aggressive checktime for external tools (Claude Code, etc.)
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "" and vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

-- Backwards compatible LSP commands for Neovim 0.12+
vim.api.nvim_create_user_command("LspRestart", "lsp restart", { desc = "Restart LSP" })
vim.api.nvim_create_user_command("LspStop", "lsp stop", { desc = "Stop LSP" })
vim.api.nvim_create_user_command("LspStart", "lsp enable", { desc = "Start LSP" })
vim.api.nvim_create_user_command("LspInfo", function()
  vim.cmd("checkhealth vim.lsp")
end, { desc = "LSP Info" })

-- Help window settings
opt.helpheight = 12 -- Minimum height of help window
opt.helplang = "en" -- Set help language to English
