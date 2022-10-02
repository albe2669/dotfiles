local P = {
  setup = function(on_attach)
    local lspconfig = require("lspconfig")

    lspconfig["pyright"].setup({
      on_attach = on_attach
    })
  end,
}

return P
