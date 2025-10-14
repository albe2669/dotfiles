return {
  server_name = { "basedpyright", "ruff" },
  setup = function(on_attach)
    vim.lsp.config("basedpyright", {
      on_attach = on_attach
    })
    vim.lsp.config("ruff", {
      on_attach = on_attach
    })
  end,
}
