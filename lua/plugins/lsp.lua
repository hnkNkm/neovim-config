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
      
      -- Manually setup LSP servers
      -- Avoid deprecated lspconfig indexing
      local ok, lspconfig = pcall(require, "lspconfig")
      if not ok then
        return
      end
      
      -- Setup lua_ls
      pcall(function()
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
      end)
      
      -- Setup other common LSP servers if they are installed
      local servers = { "pyright", "ts_ls", "html", "cssls", "jsonls" }
      for _, server in ipairs(servers) do
        pcall(function()
          lspconfig[server].setup({
            capabilities = capabilities,
          })
        end)
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

      -- LSP Keymaps are now centralized in lua/config/keymaps.lua
      -- They are automatically attached via the LspAttach autocmd
      
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        end,
      })
    end,
  },
}
