return {
  -- Better notifications (only load in regular Neovim, not in VSCode)
  {
    "rcarriga/nvim-notify",
    enabled = not vim.g.vscode,
    event = "VeryLazy",
    config = function()
      local notify = require("notify")
      notify.setup({
        -- Animation style
        stages = "fade",
        -- Default timeout for notifications
        timeout = 3000,
        -- For stages that change opacity this is treated as the highlight behind the window
        background_colour = "#000000",
        -- Icons for the different levels
        icons = {
          ERROR = "",
          WARN = "",
          INFO = "",
          DEBUG = "",
          TRACE = "✎",
        },
      })

      -- Set as default notify function
      vim.notify = notify

      -- Utility functions for notifications
      local function notify_output(command, opts)
        local output = ""
        local notification
        local notify = function(msg, level)
          if not notification then
            notification = vim.notify(msg, level, opts)
          else
            notification = vim.notify(msg, level, {
              replace = notification,
              hide_from_history = true,
            })
          end
        end

        local on_data = function(_, data)
          output = output .. table.concat(data, "\n")
          notify(output, "info")
        end

        vim.fn.jobstart(command, {
          on_stdout = on_data,
          on_stderr = on_data,
          on_exit = function(_, code)
            if code ~= 0 then
              notify("Command exited with code: " .. code, "error")
            end
          end,
        })
      end

      -- Keymaps are now centralized in lua/config/keymaps.lua

      -- Make notify globally available
      _G.notify_output = notify_output
    end,
  },

  -- Bufferline for buffer management (only load in regular Neovim, not in VSCode)
  {
    "akinsho/bufferline.nvim",
    enabled = not vim.g.vscode,
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers", -- set to "tabs" to only show tabpages instead
          numbers = "none", -- "none" | "ordinal" | "buffer_id" | "both" | function
          close_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
          right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
          left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
          middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
          indicator = {
            icon = "▎", -- this should be omitted if indicator style is not 'icon'
            style = "icon", -- 'icon' | 'underline' | 'none',
          },
          buffer_close_icon = "",
          modified_icon = "●",
          close_icon = "",
          left_trunc_marker = "",
          right_trunc_marker = "",
          max_name_length = 30,
          max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
          tab_size = 21,
          diagnostics = "nvim_lsp", -- false | "nvim_lsp" | "coc",
          diagnostics_update_in_insert = false,
          -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              separator = true,
            },
          },
          color_icons = true, -- whether or not to add the filetype icon highlights
          show_buffer_icons = true, -- disable filetype icons for buffers
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
          separator_style = "thin", -- "slant" | "thick" | "thin" | { 'any', 'any' },
          enforce_regular_tabs = false,
          always_show_bufferline = true,
          hover = {
            enabled = true,
            delay = 200,
            reveal = { "close" },
          },
          sort_by = "insert_after_current",
        },
        highlights = {
          -- Integrate with Tokyo Night theme
          fill = {
            fg = { attribute = "fg", highlight = "TabLine" },
            bg = { attribute = "bg", highlight = "TabLine" },
          },
          background = {
            fg = { attribute = "fg", highlight = "TabLine" },
            bg = { attribute = "bg", highlight = "TabLine" },
          },
          buffer_visible = {
            fg = { attribute = "fg", highlight = "TabLine" },
            bg = { attribute = "bg", highlight = "TabLine" },
          },
          close_button = {
            fg = { attribute = "fg", highlight = "TabLine" },
            bg = { attribute = "bg", highlight = "TabLine" },
          },
          close_button_visible = {
            fg = { attribute = "fg", highlight = "TabLine" },
            bg = { attribute = "bg", highlight = "TabLine" },
          },
          tab_selected = {
            fg = { attribute = "fg", highlight = "Normal" },
            bg = { attribute = "bg", highlight = "Normal" },
          },
          tab = {
            fg = { attribute = "fg", highlight = "TabLine" },
            bg = { attribute = "bg", highlight = "TabLine" },
          },
          tab_close = {
            fg = { attribute = "fg", highlight = "TabLineSel" },
            bg = { attribute = "bg", highlight = "Normal" },
          },
          duplicate_selected = {
            fg = { attribute = "fg", highlight = "TabLineSel" },
            bg = { attribute = "bg", highlight = "TabLineSel" },
            italic = true,
          },
          duplicate_visible = {
            fg = { attribute = "fg", highlight = "TabLine" },
            bg = { attribute = "bg", highlight = "TabLine" },
            italic = true,
          },
          duplicate = {
            fg = { attribute = "fg", highlight = "TabLine" },
            bg = { attribute = "bg", highlight = "TabLine" },
            italic = true,
          },
          modified = {
            fg = { attribute = "fg", highlight = "TabLine" },
            bg = { attribute = "bg", highlight = "TabLine" },
          },
          modified_selected = {
            fg = { attribute = "fg", highlight = "Normal" },
            bg = { attribute = "bg", highlight = "Normal" },
          },
          modified_visible = {
            fg = { attribute = "fg", highlight = "TabLine" },
            bg = { attribute = "bg", highlight = "TabLine" },
          },
          separator = {
            fg = { attribute = "bg", highlight = "TabLine" },
            bg = { attribute = "bg", highlight = "TabLine" },
          },
          separator_selected = {
            fg = { attribute = "bg", highlight = "Normal" },
            bg = { attribute = "bg", highlight = "Normal" },
          },
          indicator_selected = {
            fg = { attribute = "fg", highlight = "LspDiagnosticsDefaultHint" },
            bg = { attribute = "bg", highlight = "Normal" },
          },
        },
      })

      -- Keymaps are now centralized in lua/config/keymaps.lua
    end,
  },

  -- File icons (only load in regular Neovim, not in VSCode)
  {
    "nvim-tree/nvim-web-devicons",
    enabled = not vim.g.vscode,
    lazy = true,
    config = function()
      require("nvim-web-devicons").setup({
        -- Override default icons
        override = {
          zsh = {
            icon = "",
            color = "#428850",
            cterm_color = "65",
            name = "Zsh",
          },
        },
        -- Enable default icons
        default = true,
      })
    end,
  },
}
