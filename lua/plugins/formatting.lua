return {
  -- Formatting and linting (only load in regular Neovim, not in VSCode)
  {
    "nvimtools/none-ls.nvim",
    enabled = not vim.g.vscode,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics
      local code_actions = null_ls.builtins.code_actions

      null_ls.setup({
        debug = false,
        sources = {
          -- Formatting
          formatting.prettier.with({
            extra_filetypes = { "toml" },
            extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
          }),
          formatting.black.with({ extra_args = { "--fast" } }),
          formatting.stylua,
          formatting.shfmt,

          -- Diagnostics
          -- diagnostics.eslint_d,
          -- diagnostics.flake8,
          -- diagnostics.shellcheck,
          -- diagnostics.luacheck.with({
          --   extra_args = { "--globals", "vim", "--no-max-line-length" },
          -- }),

          -- Code Actions
          -- code_actions.eslint_d,
          -- code_actions.shellcheck,
          code_actions.gitsigns,
        },
        -- Format on save
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            -- Create autocommand to format on save
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  bufnr = bufnr,
                  filter = function(client)
                    -- Use none-ls for formatting instead of other LSP servers
                    return client.name == "null-ls"
                  end,
                })
              end,
            })
          end
        end,
      })

      -- Keymaps
      local map = vim.keymap.set
      map("n", "<leader>lf", function()
        vim.lsp.buf.format({ async = true })
      end, { desc = "Format document" })
    end,
  },
}
