return {
  server_name = { "gopls", "golangci_lint_ls" },
  setup = function(on_attach)
    vim.lsp.config("gopls", {
      on_attach = on_attach,
    })

    vim.lsp.config("golangci_lint_ls", {
      on_attach = on_attach,
      init_options = {
        command = {
          "golangci-lint",
          "run",
          "--output.json.path",
          "stdout",
          "--show-stats=false",
          "--issues-exit-code=1",
        },
      }
    })
  end
}
