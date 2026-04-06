return {
  -- Formatting with conform.nvim (only load in regular Neovim, not in VSCode)
  {
    "stevearc/conform.nvim",
    enabled = not vim.g.vscode,
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
  },

  -- Linting with nvim-lint (only load in regular Neovim, not in VSCode)
  {
    "mfussenegger/nvim-lint",
    enabled = not vim.g.vscode,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        python = { "ruff" },
      }

      -- Auto-lint on events
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        callback = function()
          -- Only lint if the buffer has a file type configured
          local ft = vim.bo.filetype
          if lint.linters_by_ft[ft] then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
