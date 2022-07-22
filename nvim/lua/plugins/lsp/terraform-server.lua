local T = {
  setup = function(on_attach)
    local lspconfig = require("lspconfig")

    lspconfig.terraformls.setup({

    })
  end,
}

return T
