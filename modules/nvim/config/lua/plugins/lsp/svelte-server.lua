local S = {
  setup = function(on_attach)
    local lspconfig = require("lspconfig")

    lspconfig["svelte"].setup({
      on_attach = on_attach,
    })
  end
}

return S
