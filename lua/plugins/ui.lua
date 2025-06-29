return {
  -- Status line (only load in regular Neovim, not in VSCode)
  {
    "nvim-lualine/lualine.nvim",
    enabled = not vim.g.vscode,
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional: for icons
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight", -- Use theme from colorscheme plugin
           -- See lualine documentation for more options
         },
       })
     end,
   },

  -- File explorer (only load in regular Neovim, not in VSCode)
  {
    "nvim-tree/nvim-tree.lua",
    enabled = not vim.g.vscode,
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional: for icons
    config = function()
      -- Store nvim-tree root directory globally
      vim.g.nvim_tree_root_dir = vim.fn.getcwd()
      
      require("nvim-tree").setup({
        -- See nvim-tree documentation for more options
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")
          
          -- Default mappings
          api.config.mappings.default_on_attach(bufnr)
          
          -- Override Ctrl+] to track root changes
          vim.keymap.set("n", "<C-]>", function()
            api.tree.change_root_to_node()
            -- Store the new root directory
            vim.defer_fn(function()
              local core = require("nvim-tree.core")
              local cwd = core.get_cwd()
              if cwd then
                vim.g.nvim_tree_root_dir = cwd
              end
            end, 50)
          end, { buffer = bufnr, desc = "Change root to node" })
          
          -- Add T key to open terminal in current directory
          vim.keymap.set("n", "T", function()
            local node = api.tree.get_node_under_cursor()
            if node then
              local dir
              if node.type == "directory" then
                dir = node.absolute_path
              else
                -- If it's a file, use parent directory
                dir = vim.fn.fnamemodify(node.absolute_path, ":h")
              end
              vim.cmd("ToggleTerm direction=horizontal dir=" .. vim.fn.fnameescape(dir))
            end
          end, { buffer = bufnr, desc = "Open terminal here" })
        end,
      })

       -- Keymaps for nvim-tree
      local map = vim.keymap.set
      map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    end,
  },
}
