return {
  -- LSP Configuration & Manager (only load in regular Neovim, not in VSCode)
  {
    "neovim/nvim-lspconfig",
    enabled = not vim.g.vscode,
    dependencies = {
      -- Automatically install LSPs, formatters, linters
      "williamboman/mason.nvim",
      -- "williamboman/mason-lspconfig.nvim", -- Temporarily disabled due to errors

      -- Useful status updates for LSP
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      -- First ensure mason is setup
      require("mason").setup()
      
      -- Get the LSP capabilities provided by nvim-cmp
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      -- Manually setup LSP servers without mason-lspconfig
      local lspconfig = require("lspconfig")
      
      -- Setup lua_ls
      if lspconfig.lua_ls then
        lspconfig.lua_ls.setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = { library = vim.api.nvim_get_runtime_file("", true) },
              telemetry = { enable = false },
            },
          },
        })
      end
      
      -- Setup other common LSP servers if they are installed
      local servers = { "pyright", "ts_ls", "html", "cssls", "jsonls" }
      for _, server in ipairs(servers) do
        if lspconfig[server] then
          lspconfig[server].setup({
            capabilities = capabilities,
          })
        end
      end
      
      --[[ Disabled mason-lspconfig handlers due to errors
        -- Default handler: Setup server with capabilities
        function(server_name)
          -- Skip if server configuration doesn't exist
          local ok, lspconfig = pcall(require, "lspconfig")
          if ok and lspconfig[server_name] then
            lspconfig[server_name].setup({
              capabilities = capabilities,
            })
          end
        end,
        -- Custom handler for lua_ls
        ["lua_ls"] = function()
          require("lspconfig").lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                telemetry = { enable = false },
              },
            },
          })
        end,
         -- Add custom handlers for other servers if needed
       })
      --]]

       -- LSP Keymaps (add these to your keymaps file or keep them here)
      local map = vim.keymap.set
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          map("n", "gD", vim.lsp.buf.declaration, opts)
          map("n", "gd", vim.lsp.buf.definition, opts)
          map("n", "K", vim.lsp.buf.hover, opts)
          map("n", "gi", vim.lsp.buf.implementation, opts)
          map("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
          map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
          map("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          map("n", "<leader>D", vim.lsp.buf.type_definition, opts)
          map("n", "<leader>rn", vim.lsp.buf.rename, opts)
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
          map("n", "gr", vim.lsp.buf.references, opts)
          map("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
          -- Diagnostics
          map("n", "[d", vim.diagnostic.goto_prev, opts)
          map("n", "]d", vim.diagnostic.goto_next, opts)
          map("n", "<leader>lq", vim.diagnostic.setloclist, opts)
        end,
      })
    end,
  },
}
