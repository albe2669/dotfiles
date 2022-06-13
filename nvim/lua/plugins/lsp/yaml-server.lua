local Y = {
  setup = function(on_attach)
    local lspconfig = require("lspconfig")
    
    lspconfig['yamlls'].setup({
      on_attach = on_attach,
      capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
      settings = {
        yaml = {
          schemas = {
            ["kubernetes"] = "*.yaml"
          }
        }
      }
    })
  end
}

return Y
