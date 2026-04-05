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
            return 15  -- Height for horizontal split
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4  -- Width for vertical split (40%)
          end
        end,
        open_mapping = [[<c-\>]], -- Ctrl+\ to toggle terminal
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = false, -- Disable to avoid conflicts with Claude Code
        persist_size = true,
        direction = "float", -- Default direction
        close_on_exit = true,
        shell = vim.o.shell,
        hidden = true,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
        -- Hide terminal buffers from buffer list
        on_create = function(term)
          vim.opt_local.buflisted = false
        end,
      })

      -- Custom terminal instances
      local Terminal = require("toggleterm.terminal").Terminal

      -- Lazygit
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

      -- Node REPL
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

      -- Python REPL
      local python = Terminal:new({
        cmd = "python3",
        hidden = true,
        direction = "float",
        on_open = function(term)
          vim.opt_local.buflisted = false
        end,
      })

      function _G.toggle_python()
        python:toggle()
      end

      -- Simple terminal toggle functions with consistent IDs
      function _G.smart_toggle_term_default()
        vim.cmd("1ToggleTerm direction=float")
      end
      
      function _G.smart_toggle_term_float()
        vim.cmd("2ToggleTerm direction=float")
      end
      
      function _G.smart_toggle_term_horizontal()
        vim.cmd("3ToggleTerm direction=horizontal")
      end
      
      function _G.smart_toggle_term_vertical()
        vim.cmd("4ToggleTerm direction=vertical")
      end
      
      function _G.smart_toggle_term_small()
        vim.cmd("5ToggleTerm direction=horizontal size=15")
      end
      
      function _G.smart_toggle_term_tab()
        vim.cmd("6ToggleTerm direction=tab")
      end
    end,
  },
}