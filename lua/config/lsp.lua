-- LSP Configuration for Neovim 0.12+
-- Uses native vim.lsp.config() and vim.lsp.enable() with lsp/*.lua files
-- LSP servers are provided by:
--   1. direnv project environment (flake.nix)
--   2. Global Nix packages (home-manager)

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

-- LSP server configurations (only enable if executable is found)
-- Configs are in lsp/*.lua, this just enables them
local server_cmds = {
  lua_ls = "lua-language-server",
  ts_ls = "typescript-language-server",
  pyright = "pyright-langserver",
  nil_ls = "nil",
  gopls = "gopls",
  zls = "zls",
  jsonls = "vscode-json-language-server",
  rust_analyzer = "rust-analyzer",
  denols = "deno", -- Deno LSP
}

-- Only enable servers that are available in PATH
local servers_to_enable = {}
for server, cmd in pairs(server_cmds) do
  if vim.fn.executable(cmd) == 1 then
    table.insert(servers_to_enable, server)
  end
end

-- Get capabilities from blink.cmp and apply to all servers
local ok, blink = pcall(require, "blink.cmp")
if ok then
  local capabilities = blink.get_lsp_capabilities()
  for _, name in ipairs(servers_to_enable) do
    vim.lsp.config(name, { capabilities = capabilities })
  end
end

-- Enable available servers
if #servers_to_enable > 0 then
  vim.lsp.enable(servers_to_enable)
end

-- LspAttach autocmd for buffer-local settings
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
  end,
})
