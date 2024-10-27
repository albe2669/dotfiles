return {
  server_name = "omnisharp",
  setup = function(on_attach)
    local lspconfig = require("lspconfig")

    lspconfig.omnisharp.setup({
      on_attach = on_attach
    })
  end,
}
