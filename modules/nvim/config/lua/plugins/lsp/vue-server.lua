local V = {
  setup = function(on_attach)
    local lspconfig = require('lspconfig')

    print("Setting up vue server")

    lspconfig['volar'].setup({ on_attach = on_attach })
    lspconfig['emmet_language_server'].setup({ on_attach = on_attach })
    print("Vue server setup complete")
  end
}

return V
