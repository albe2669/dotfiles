local C = {
  setup = function(on_attach)
    local lspconfig = require("lspconfig")

    lspconfig.omnisharp.setup({
      on_attach = on_attach
    })
  end,
}

return C
