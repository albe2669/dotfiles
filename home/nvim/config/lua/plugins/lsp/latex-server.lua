local T = {
  setup = function(on_attach)
    local lspconfig = require("lspconfig")

    lspconfig["texlab"].setup({
      on_attach = on_attach,
    })
  end
}

return T