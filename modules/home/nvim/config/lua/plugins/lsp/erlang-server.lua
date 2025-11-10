return {
  server_name = "elp",
  setup = function(on_attach)
    vim.lsp.config("elp", {
      on_attach = on_attach,
    })
  end
}
