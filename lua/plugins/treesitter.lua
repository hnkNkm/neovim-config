return {
  -- Treesitter configuration
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", -- Command to build/update parsers
    config = function()
      require("nvim-treesitter.configs").setup({
        -- A list of parser names, or "all"
        ensure_installed = {
          "c",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "javascript",
          "typescript",
          "python",
          "html",
          "css",
          "json",
          "yaml",
          "markdown",
          "markdown_inline",
          -- Add other languages you frequently use
        },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        highlight = {
          enable = true, -- Enable syntax highlighting
          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
         indent = { enable = true }, -- Enable indentation based on treesitter
         -- Other modules can be enabled here, e.g., incremental selection, textobjects
       })
     end,
   },
}
