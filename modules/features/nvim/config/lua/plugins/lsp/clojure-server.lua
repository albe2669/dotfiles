return {
  server_name = "clojure_lsp",
  setup = function(on_attach)
    vim.lsp.config("clojure_lsp", {
      on_attach = on_attach,
    })
  end
}
