return {
  server_name = "eslint",
  setup = function(on_attach)
    vim.lsp.config("eslint", {
      root_markers = { ".eslintrc", ".eslintrc.js", "eslint.config.js", ".eslintrc.json",
        ".eslintrc.yml", ".eslintrc.yaml" },
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.documentRangeFormattingProvider = true
        on_attach(client, bufnr)
      end,
      settings = {
        format = {
          enable = true,
        },
      },
    })
  end,
}
