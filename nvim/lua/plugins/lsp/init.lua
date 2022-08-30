local u = require("utils")

local lsp = vim.lsp
local api = vim.api

local border_opts = { border = "single", focusable = false, scope = "line" }

vim.diagnostic.config({ virtual_text = true, float = border_opts })

lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, border_opts)
lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, border_opts)

-- use lsp formatting if it's available (and if it's good)
-- otherwise, fall back to null-ls
local preferred_formatting_clients = { "eslint" }
local fallback_formatting_client = "null-ls"

local formatting = function()
  local bufnr = api.nvim_get_current_buf()

  local selected_client
    for _, client in ipairs(lsp.get_active_clients()) do
        if vim.tbl_contains(preferred_formatting_clients, client.name) then
            selected_client = client
            break
        end

        if client.name == fallback_formatting_client then
            selected_client = client
        end
    end

    if not selected_client then
        return
    end

    local params = lsp.util.make_formatting_params()
    local result, err = selected_client.request_sync("textDocument/formatting", params, 5000, bufnr)
    if err then
        local err_msg = type(err) == "string" and err or err.message
        vim.notify("global.lsp.formatting: " .. err_msg, vim.log.levels.WARN)
        return
    end

    if result and result.result then
        local offset_encoding = selected_client.offset_encoding
        lsp.util.apply_text_edits(result.result, bufnr, offset_encoding)
    end
end

global.lsp = {
    border_opts = border_opts,
    formatting = formatting,
}

local on_attach = function(client, bufnr)
    vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
    vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
    vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
    vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
    vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
    vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
    vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
    vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
    vim.cmd("command! LspDiagPrev lua vim.diagnostic.goto_prev()")
    vim.cmd("command! LspDiagNext lua vim.diagnostic.goto_next()")
    vim.cmd("command! LspDiagLine lua vim.diagnostic.open_float()")
    vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")

    u.buf_map(bufnr, "n", "gd", ":LspDef<CR>")
    u.buf_map(bufnr, "n", "gy", ":LspTypeDef<CR>")
    u.buf_map(bufnr, "n", "gI", ":LspImplementation<CR>")
    u.buf_map(bufnr, "n", "K", ":LspHover<CR>")
    u.buf_map(bufnr, "n", "[a", ":LspDiagPrev<CR>")
    u.buf_map(bufnr, "n", "]a", ":LspDiagNext<CR>")
    u.buf_map(bufnr, "n", "<Leader>lr", ":LspRename<CR>")
    u.buf_map(bufnr, "n", "<Leader>la", ":LspCodeAction<CR>")
    u.buf_map(bufnr, "n", "<Leader>ld", ":LspDiagLine<CR>")
    u.buf_map(bufnr, "i", "<Leader>lh", "<cmd> LspSignatureHelp<CR>")

    if client.supports_method("textDocument/formatting") then
      vim.cmd("autocmd BufWritePre <buffer> lua global.lsp.formatting()")
    end

    if client.supports_method("textDocument/completion") then
      vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
      u.buf_map(bufnr, "i", "<C-Space>", "<C-x><C-o>")
    end
end

for _, config in ipairs({ 
  "null-ls",
  "rs-server",
  "ts-server",
  "eslint-server",
  "yaml-server",
  "lua-server",
  "bash-server",
  "terraform-server",
  "dagger-server",
  "c-server",
  "cmake-server",
}) do
  require("plugins.lsp." .. config).setup(on_attach)
end

require("mason").setup({})
require("mason-lspconfig").setup({
  automatic_installation = true,
})

-- Hide lspconfig messages
local notify = vim.notify
vim.notify = function(msg, ...)
  if msg:match("%[lspconfig%]") then
    return
  end

  notify(msg, ...)
end


