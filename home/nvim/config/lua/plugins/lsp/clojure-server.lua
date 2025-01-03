return {
  server_name = "clojure_lsp",
  setup = function(on_attach)
    local lspconfig = require("lspconfig")

    lspconfig["clojure_lsp"].setup({
      on_attach = on_attach,
    })
  end
}
