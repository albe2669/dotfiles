return {
  server_name = { "vue_ls", "emmet_language_server" },
  setup = function(on_attach)
    vim.lsp.config('vue_ls', {
      on_attach = on_attach,
      settings = {
        html = {
          format = {
            wrapAttributes = "force-expand-multiline",
          },
        },
      },
    })
    vim.lsp.config('emmet_language_server', {
      on_attach = on_attach,
      file_types = { "html", "css", "scss", "less", "vue", "typescript" }
    })
  end
}
