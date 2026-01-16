return {
  -- Terminal management (only load in regular Neovim, not in VSCode)
  {
    "akinsho/toggleterm.nvim",
    enabled = not vim.g.vscode,
    version = "*",
    config = function()

      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15  -- 水平分割時の高さ（行数）
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4  -- 垂直分割時の幅（40%）
          end
        end,
        open_mapping = [[<c-\>]], -- Ctrl+\ to toggle terminal
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float", -- 'vertical', 'horizontal', 'tab', 'float'
        close_on_exit = true,
        shell = vim.o.shell,
        hidden = true, -- Hide terminal buffers from buffer list
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
        -- Exclude terminal buffers from buffer list
        on_create = function(term)
          vim.opt_local.buflisted = false
        end,
      })

      -- Custom terminal functions
      local Terminal = require("toggleterm.terminal").Terminal

      -- Lazygit terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        on_open = function(term)
          vim.opt_local.buflisted = false
        end,
      })

      function _G.toggle_lazygit()
        lazygit:toggle()
      end

      -- Node terminal
      local node = Terminal:new({
        cmd = "node",
        hidden = true,
        direction = "float",
        on_open = function(term)
          vim.opt_local.buflisted = false
        end,
      })

      function _G.toggle_node()
        node:toggle()
      end

      -- Python terminal
      local python = Terminal:new({
        cmd = "python",
        hidden = true,
        direction = "float",
        on_open = function(term)
          vim.opt_local.buflisted = false
        end,
      })

      function _G.toggle_python()
        python:toggle()
      end

      -- Additional keymaps for toggleterm
      local map = vim.keymap.set

      -- Main terminal keymaps using numbered terminals for different directions
      -- Using different IDs allows multiple terminals but only one per direction
      map("n", "<leader>tt", "<cmd>1ToggleTerm direction=float<CR>", { desc = "Toggle floating terminal" })
      map("n", "<leader>tv", "<cmd>2ToggleTerm size=80 direction=vertical<CR>", { desc = "Toggle terminal right (vertical)" })
      map("n", "<leader>ts", "<cmd>3ToggleTerm size=15 direction=horizontal<CR>", { desc = "Toggle terminal below (horizontal)" })
      map("n", "<leader>tT", "<cmd>4ToggleTerm direction=tab<CR>", { desc = "Toggle terminal in new tab" })

      -- REPL keymaps
      map("n", "<leader>tg", "<cmd>lua toggle_lazygit()<CR>", { desc = "Toggle Lazygit" })
      map("n", "<leader>tn", "<cmd>lua toggle_node()<CR>", { desc = "Toggle Node REPL" })
      map("n", "<leader>tp", "<cmd>lua toggle_python()<CR>", { desc = "Toggle Python REPL" })
    end,
  },
}
