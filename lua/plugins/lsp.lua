return {
  -- LSP Configuration & Manager (only load in regular Neovim, not in VSCode)
  {
    "neovim/nvim-lspconfig",
    enabled = not vim.g.vscode,
    dependencies = {
      { "williamboman/mason.nvim", opts = {} },
      {
        "mason-org/mason-lspconfig.nvim",
        opts = {
          ensure_installed = { "lua_ls", "pyright", "ts_ls" },
          automatic_enable = false, -- We manually enable servers below
        },
      },
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      -- Get capabilities from blink.cmp
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Configure servers using Neovim 0.11+ vim.lsp.config API
      -- nvim-lspconfig provides base configs, we extend them here

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

      vim.lsp.config("zls", {
        capabilities = capabilities,
        settings = {
          zls = {
            enable_snippets = true,
            enable_argument_placeholders = true,
            enable_ast_check_diagnostics = true,
            enable_build_on_save = false,
            enable_autofix = true,
            enable_inlay_hints = true,
          },
        },
      })

      -- Configure other servers with just capabilities
      local servers = {
        "pyright", "ts_ls", "gopls",
        "html", "cssls", "jsonls", "yamlls",
        "bashls", "marksman", "nil_ls",
      }
      for _, server in ipairs(servers) do
        vim.lsp.config(server, { capabilities = capabilities })
      end

      -- Only enable rust_analyzer if rustc is available
      if vim.fn.executable("rustc") == 1 then
        vim.lsp.config("rust_analyzer", { capabilities = capabilities })
        servers[#servers + 1] = "rust_analyzer"
      end

      -- Enable all configured servers
      local enabled = { "lua_ls", "zls" }
      for _, s in ipairs(servers) do
        enabled[#enabled + 1] = s
      end
      vim.lsp.enable(enabled)

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        end,
      })
    end,
  },
}
