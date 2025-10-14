return {
  server_name = "tailwindcss",
  setup = function(on_attach)
    vim.lsp.config("tailwindcss", {
      on_attach = on_attach,
    })
  end
}
