-- LSP Configuration for Neovim 0.12+
-- Uses native vim.lsp.config() and vim.lsp.enable() with lsp/*.lua files

if vim.g.vscode then
  return
end

-- Diagnostic configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
})

-- List of LSP servers to enable (configs are in lsp/*.lua)
local servers = {
  "lua_ls",
  "ts_ls",
  "pyright",
  "nil_ls",
  "gopls",
  "zls",
  "jsonls",
}

-- Conditionally add rust_analyzer
if vim.fn.executable("rustc") == 1 then
  table.insert(servers, "rust_analyzer")
end

-- Get capabilities from blink.cmp and apply to all servers
local ok, blink = pcall(require, "blink.cmp")
if ok then
  local capabilities = blink.get_lsp_capabilities()
  for _, name in ipairs(servers) do
    vim.lsp.config(name, { capabilities = capabilities })
  end
end

-- Enable all servers
vim.lsp.enable(servers)

-- LspAttach autocmd for buffer-local settings
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
  end,
})
