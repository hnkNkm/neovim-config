return {
  -- Telescope for fuzzy finding (load with limited functionality in VSCode)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { 
        "nvim-telescope/telescope-fzf-native.nvim", 
        build = "make",
        cond = function()
          return vim.fn.executable "make" == 1
        end,
      },
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous, -- move to prev result
              ["<C-j>"] = actions.move_selection_next, -- move to next result
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      -- Load extensions
      pcall(telescope.load_extension, "fzf")

      -- Keymaps
      local map = vim.keymap.set
      
      -- Different keymaps based on whether we're in VSCode or not
      if vim.g.vscode then
        -- In VSCode, only enable help-related features
        map("n", "<leader>hk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })
        map("n", "<leader>hh", "<cmd>Telescope help_tags<CR>", { desc = "Help pages" })
        map("n", "<leader>hm", "<cmd>Telescope man_pages<CR>", { desc = "Man pages" })
        map("n", "<leader>hc", "<cmd>Telescope commands<CR>", { desc = "Commands" })
      else
        -- In regular Neovim, enable all features
        -- Find files
        map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
        map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Find recent files" })
        map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
        
        -- Find in files
        map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Find text in project" })
        map("n", "<leader>fw", "<cmd>Telescope grep_string<CR>", { desc = "Find word under cursor" })
        
        -- Git
        map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git commits" })
        map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Git status" })
        
        -- LSP
        map("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Document symbols" })
        map("n", "<leader>lr", "<cmd>Telescope lsp_references<CR>", { desc = "References" })
        map("n", "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Document diagnostics" })
        map("n", "<leader>lD", "<cmd>Telescope diagnostics<CR>", { desc = "Workspace diagnostics" })
        
        -- Help
        map("n", "<leader>hk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })
        map("n", "<leader>hh", "<cmd>Telescope help_tags<CR>", { desc = "Help pages" })
        map("n", "<leader>hm", "<cmd>Telescope man_pages<CR>", { desc = "Man pages" })
        map("n", "<leader>hc", "<cmd>Telescope commands<CR>", { desc = "Commands" })
      end
    end,
  },
}
