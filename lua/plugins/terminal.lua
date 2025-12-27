return {
  -- Terminal management (only load in regular Neovim, not in VSCode)
  {
    "akinsho/toggleterm.nvim",
    enabled = not vim.g.vscode,
    version = "*",
    config = function()
      -- Function to get current directory from nvim-tree or current buffer
      local function get_current_dir()
        -- First priority: If nvim-tree is open, get the node under cursor
        local nvim_tree_api_ok, api = pcall(require, "nvim-tree.api")
        if nvim_tree_api_ok then
          -- Check if nvim-tree is open by looking for nvim-tree buffer
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "filetype") == "NvimTree" then
              -- Save current window
              local current_win = vim.api.nvim_get_current_win()
              
              -- Find nvim-tree window
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_get_buf(win) == buf then
                  -- Switch to nvim-tree window temporarily
                  vim.api.nvim_set_current_win(win)
                  local node = api.tree.get_node_under_cursor()
                  
                  -- Switch back to original window
                  vim.api.nvim_set_current_win(current_win)
                  
                  if node then
                    if node.type == "directory" then
                      return node.absolute_path
                    else
                      -- If it's a file, use parent directory
                      return vim.fn.fnamemodify(node.absolute_path, ":h")
                    end
                  end
                  break
                end
              end
              break
            end
          end
        end
        
        -- Second priority: Check global nvim-tree root directory variable
        if vim.g.nvim_tree_root_dir and vim.g.nvim_tree_root_dir ~= "" then
          return vim.g.nvim_tree_root_dir
        end
        
        -- Third priority: Try to get nvim-tree's root directory from core module
        local nvim_tree_ok = pcall(require, "nvim-tree")
        if nvim_tree_ok then
          local nvim_tree_core_ok, core = pcall(require, "nvim-tree.core")
          if nvim_tree_core_ok then
            local cwd = core.get_cwd()
            if cwd and cwd ~= "" then
              return cwd
            end
          end
        end
        
        -- Fallback to current buffer's directory
        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname ~= "" then
          return vim.fn.fnamemodify(bufname, ":h")
        end
        
        -- Final fallback to current working directory
        return vim.fn.getcwd()
      end

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

      -- Create dedicated terminals for each direction (using fixed IDs)
      -- ID 1: float, ID 2: vertical, ID 3: horizontal, ID 4: tab
      local float_term = Terminal:new({
        direction = "float",
        hidden = true,
        on_open = function(term)
          vim.opt_local.buflisted = false
        end,
      })

      local vertical_term = Terminal:new({
        direction = "vertical",
        hidden = true,
        on_open = function(term)
          vim.opt_local.buflisted = false
        end,
      })

      local horizontal_term = Terminal:new({
        direction = "horizontal",
        hidden = true,
        on_open = function(term)
          vim.opt_local.buflisted = false
        end,
      })

      local tab_term = Terminal:new({
        direction = "tab",
        hidden = true,
        on_open = function(term)
          vim.opt_local.buflisted = false
        end,
      })

      -- Main terminal keymaps (each toggles its own dedicated terminal)
      map("n", "<leader>tt", function() float_term:toggle() end, { desc = "Toggle floating terminal" })
      map("n", "<leader>tv", function() vertical_term:toggle() end, { desc = "Toggle terminal right (vertical)" })
      map("n", "<leader>ts", function() horizontal_term:toggle() end, { desc = "Toggle terminal below (horizontal)" })
      map("n", "<leader>tT", function() tab_term:toggle() end, { desc = "Toggle terminal in new tab" })

      -- REPL keymaps
      map("n", "<leader>tg", "<cmd>lua toggle_lazygit()<CR>", { desc = "Toggle Lazygit" })
      map("n", "<leader>tn", "<cmd>lua toggle_node()<CR>", { desc = "Toggle Node REPL" })
      map("n", "<leader>tp", "<cmd>lua toggle_python()<CR>", { desc = "Toggle Python REPL" })
    end,
  },
}
