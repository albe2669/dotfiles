return {
  server_name = "graphql",
  setup = function(on_attach)
    vim.lsp.config("graphql", {
      on_attach = on_attach
    })
  end,
}
