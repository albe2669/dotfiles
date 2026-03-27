return {
  server_name = "nil_ls",
  dont_install = true,
  setup = function(on_attach)
    vim.lsp.config("nil_ls", {
      on_attach = on_attach,
    })
  end,
}
