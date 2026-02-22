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
        insert_mappings = false, -- Disable global insert mappings to avoid conflicts
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

      -- Smart terminal toggle functions
      -- These will close any existing terminal before opening a new one with different direction
      local function get_open_terminals()
        local terminals = require("toggleterm.terminal").get_all()
        local open_terms = {}
        for _, term in ipairs(terminals) do
          if term:is_open() then
            table.insert(open_terms, term)
          end
        end
        return open_terms
      end
      
      local function smart_toggle_term(id, direction, size)
        local open_terms = get_open_terminals()
        local target_term = nil
        
        -- Find if the target terminal exists
        for _, term in ipairs(require("toggleterm.terminal").get_all()) do
          if term.id == id then
            target_term = term
            break
          end
        end
        
        -- If target terminal is already open, just toggle it
        if target_term and target_term:is_open() then
          target_term:toggle()
          return
        end
        
        -- If other terminals are open and we're opening a non-floating terminal
        if #open_terms > 0 and direction ~= "float" and direction ~= "tab" then
          -- Close other non-floating terminals to avoid stacking
          for _, term in ipairs(open_terms) do
            if term.id ~= id and term.direction ~= "float" and term.direction ~= "tab" then
              term:close()
            end
          end
        end
        
        -- Open the target terminal
        local cmd = string.format("%dToggleTerm", id)
        if direction then
          cmd = cmd .. " direction=" .. direction
        end
        if size then
          cmd = cmd .. " size=" .. tostring(size)
        end
        vim.cmd(cmd)
      end
      
      -- Global functions for smart terminal toggling
      function _G.smart_toggle_term_default()
        smart_toggle_term(1, "float", nil)
      end
      
      function _G.smart_toggle_term_float()
        smart_toggle_term(2, "float", nil)
      end
      
      function _G.smart_toggle_term_horizontal()
        smart_toggle_term(3, "horizontal", nil)
      end
      
      function _G.smart_toggle_term_vertical()
        smart_toggle_term(4, "vertical", nil)
      end
      
      function _G.smart_toggle_term_small()
        smart_toggle_term(5, "horizontal", 15)
      end
      
      function _G.smart_toggle_term_tab()
        smart_toggle_term(6, "tab", nil)
      end

      -- Keymaps are now centralized in lua/config/keymaps.lua
      -- Terminal-specific functions are kept here for toggleterm to use
    end,
  },
}
