local Y = {
  setup = function(on_attach)
    local lspconfig = require("lspconfig")

    lspconfig['yamlls'].setup({
      on_attach = on_attach,
      capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
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

return Y
