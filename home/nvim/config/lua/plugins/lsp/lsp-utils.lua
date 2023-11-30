local u = require("utils")

local lsp = vim.lsp
local api = vim.api

local utils = {}

function utils.formatting()
  local bufnr = api.nvim_get_current_buf()
  -- Loop all the clients and use their formatting
  for _, client in ipairs(lsp.get_active_clients()) do
    if client.name == "null-ls" or client.name == "clangd" then
      return
    end
    if client.supports_method("textDocument/formatting") then
      local params = lsp.util.make_formatting_params()
      local result, err = client.request_sync("textDocument/formatting", params, 5000, bufnr)
      if err then
        local err_msg = type(err) == "string" and err or err.message
        vim.notify("global.lsp.formatting: " .. err_msg, vim.log.levels.WARN)
        return
      end

      if result and result.result then
        local offset_encoding = client.offset_encoding
        lsp.util.apply_text_edits(result.result, bufnr, offset_encoding)
      end
    end
  end
end

function utils.on_attach(client, bufnr)
  vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
  vim.cmd("command! LspFormatting lua vim.lsp.buf.format({ async = true})")
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

return utils
