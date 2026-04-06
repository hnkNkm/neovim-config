return {
  -- LSP Configuration & Manager (only load in regular Neovim, not in VSCode)
  {
    "neovim/nvim-lspconfig",
    enabled = not vim.g.vscode,
    dependencies = {
      -- Automatically install LSPs, formatters, linters
      { "williamboman/mason.nvim", opts = {} },
      {
        "mason-org/mason-lspconfig.nvim",
        opts = {
          ensure_installed = { "lua_ls", "pyright", "ts_ls", "html", "cssls", "jsonls" },
          automatic_installation = true, -- Automatically install missing servers
          automatic_enable = true, -- Automatically enable installed servers
        },
      },

      -- Useful status updates for LSP
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      -- Mason is already setup via opts in dependencies
      -- Setup mason-lspconfig (will be configured via opts above)
      -- This handles automatic installation and enabling of servers

      -- Get the LSP capabilities provided by blink.cmp
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      
      -- Configure servers via vim.lsp.config (Neovim 0.11+)
      -- mason-lspconfig will automatically enable these when installed
      
      -- Configure lua_ls with custom settings
      vim.lsp.config("lua_ls", {
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
      
      -- Configure other servers with just capabilities
      -- This includes both ensure_installed servers and any others that might be auto-installed
      local servers = { 
        "pyright", "ts_ls", "html", "cssls", "jsonls",
        -- Additional servers that might be auto-installed
        "rust_analyzer", "gopls", "clangd", "bashls", "dockerls", 
        "yamlls", "taplo", "marksman", "eslint", "tailwindcss"
      }
      for _, server in ipairs(servers) do
        vim.lsp.config(server, {
          capabilities = capabilities,
        })
      end
      

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
