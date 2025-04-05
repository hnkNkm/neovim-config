-- Custom filetype settings
vim.filetype.add({
  -- Detect and assign filetype based on extension
  extension = {
    -- Web development
    jsx = "javascriptreact",
    tsx = "typescriptreact",
    mdx = "markdown.mdx",
    -- Configuration files
    conf = "conf",
    -- Data files
    toml = "toml",
    -- Shell scripts
    zsh = "zsh",
    -- Custom extensions
    template = "template",
  },
  -- Detect and assign filetype based on filename
  filename = {
    [".env"] = "sh",
    ["Dockerfile"] = "dockerfile",
    [".dockerignore"] = "gitignore",
    [".eslintrc"] = "json",
    [".prettierrc"] = "json",
    ["tsconfig.json"] = "jsonc",
    ["package.json"] = "json",
  },
  -- Detect and assign filetype based on pattern
  pattern = {
    -- Detect based on shebang
    [".*%.env%..*"] = "sh",
    [".*%.conf"] = "conf",
    -- Detect rc files
    ["%.?.*rc"] = "json",
  },
})

-- Load this module in init.lua
return {}
