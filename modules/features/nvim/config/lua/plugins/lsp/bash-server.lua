return {
  server_name = "bashls",
  setup = function(on_attach)
    vim.lsp.config("bashls", {
      on_attach = on_attach
    })
  end,
}
