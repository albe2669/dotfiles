return {
  server_name = { "vue_ls", "emmet_language_server" },
  setup = function(on_attach)
    local lspconfig = require('lspconfig')

    lspconfig['vue_ls'].setup({
      on_attach = on_attach,
      settings = {
        html = {
          format = {
            wrapAttributes = "force-expand-multiline",
          },
        },
      },
    })
    lspconfig['emmet_language_server'].setup({
      on_attach = on_attach,
      file_types = { "html", "css", "scss", "less", "vue", "typescript" }
    })
  end
}
