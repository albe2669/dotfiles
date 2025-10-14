return {
  server_name = "texlab",
  setup = function(on_attach)
    vim.lsp.config("texlab", {
      on_attach = on_attach,
    })
  end
}
