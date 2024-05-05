return {
  server_name = { "volar", "emmet_language_server" },
  setup = function(on_attach)
    local lspconfig = require('lspconfig')

    lspconfig['volar'].setup({
      on_attach = on_attach,
      settings = {
        html = {
          format = {
            wrapAttributes = "force-expand-multiline",
          },
        },
      },
    })
    lspconfig['emmet_language_server'].setup({ on_attach = on_attach })
  end
}
