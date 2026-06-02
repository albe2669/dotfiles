return {
  server_name = "cmake",
  setup = function (on_attach)
    vim.lsp.config("cmake", {
      on_attach = on_attach,
    })
  end
}
