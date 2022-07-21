local B = {
  setup = function(on_attach)
    local lspconfig = require("lspconfig")

    lspconfig.bashls.setup({

    })
  end,
}

return B
