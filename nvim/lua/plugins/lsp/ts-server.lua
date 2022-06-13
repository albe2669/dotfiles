local u = require("utils")

local T = {
  setup = function(on_attach)
    local nvim_lsp = require('lspconfig')
    local ts_utils = require("nvim-lsp-ts-utils")

    nvim_lsp["tsserver"].setup({
      root_dir = nvim_lsp.util.root_pattern("package.json"),
      init_options = ts_utils.init_options,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        ts_utils.setup({})
        ts_utils.setup_client(client)        

        u.buf_map(bufnr, "n", "gs", ":TSLspOrganize<CR>")
        u.buf_map(bufnr, "n", "gi", ":TSLspRenameFile<CR>")
        u.buf_map(bufnr, "n", "go", ":TSLspImportAll<CR>")
      end,
    })
  end
}

return T
