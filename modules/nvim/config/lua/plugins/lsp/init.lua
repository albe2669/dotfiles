local lu = require("plugins.lsp.lsp-utils")

local lsp = vim.lsp

local border_opts = { border = "single", focusable = false, scope = "line" }

vim.diagnostic.config({ virtual_text = true, float = border_opts })

lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, border_opts)
lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, border_opts)

global.lsp = {
  border_opts = border_opts,
  formatting = lu.formatting,
}

for _, config in ipairs({
  "bash-server",
  "c-server",
  "cmake-server",
  "csharp-server",
  "dagger-server",
  "eslint-server",
  "go-server",
  "lua-server",
  "python-server",
  "rs-server",
  "svelte-server",
  "tailwindcss-server",
  "terraform-server",
  "ts-server",
  "yaml-server",
}) do
  require("plugins.lsp." .. config).setup(lu.on_attach)
end

require("mason").setup({})
require("mason-lspconfig").setup({
  automatic_installation = true,
  ensure_installed = {
    "bashls",
    "clangd",
    "cmake",
    "eslint",
    "gopls",
    "omnisharp",
    "pylsp",
    "rust_analyzer",
    "svelte",
    "tailwindcss",
    "terraformls",
    "tflint",
    "tsserver",
    "yamlls",
  }
})

-- Hide lspconfig messages
local notify = vim.notify
vim.notify = function(msg, ...)
  if msg:match("%[lspconfig%]") then
    return
  end

  notify(msg, ...)
end
