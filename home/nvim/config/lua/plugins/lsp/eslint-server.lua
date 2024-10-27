return {
  server_name = "eslint",
  setup = function(on_attach)
    local lspconfig = require("lspconfig")

    lspconfig["eslint"].setup({
      root_dir = lspconfig.util.root_pattern(".eslintrc", ".eslintrc.js"),
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
