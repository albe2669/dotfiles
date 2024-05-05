return {
  server_name = {"gopls", "golangci_lint_ls"},
  setup = function(on_attach)
    local lspconfig = require("lspconfig")

    lspconfig["gopls"].setup({
      on_attach = on_attach,
    })

    lspconfig["golangci_lint_ls"].setup({
      on_attach = on_attach,
    })
  end
}
