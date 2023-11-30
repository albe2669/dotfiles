local G = {
  setup = function(on_attach)
    local lspconfig = require("lspconfig")

    lspconfig["graphql"].setup({
      on_attach = on_attach
    })
  end,
}

return G
