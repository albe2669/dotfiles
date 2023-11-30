local N = {
  setup = function(on_attach)
    local lspconfig = require('lspconfig')

    lspconfig["nil_ls"].setup({
      on_attach = on_attach,
    })
  end,
}

return N
