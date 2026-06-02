return {
  server_name = "yamlls",
  setup = function(on_attach)
    vim.lsp.config('yamlls', {
      on_attach = on_attach,
      capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
      settings = {
        yaml = {
          schemas = {
            ["kubernetes"] = ".infrastructure/kubernetes/**/*.yaml",
            ["https://json.schemastore.org/github-action.json"] = ".github/actions/**/*.yml",
            ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/**/*.yml",
          }
        }
      }
    })
  end
}
