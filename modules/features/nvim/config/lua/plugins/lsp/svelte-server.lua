return {
  server_name = "svelte",
  setup = function(on_attach)
    vim.lsp.config("svelte", {
      on_attach = on_attach,
    })
  end
}
