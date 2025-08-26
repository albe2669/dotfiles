return {
  server_name = "java_language_server",
  setup = function(on_attach)
    local lspconfig = require("lspconfig")

    lspconfig["java_language_server"].setup({
      on_attach = on_attach,
    })
  end
}
