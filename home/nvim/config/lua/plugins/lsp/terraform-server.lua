return {
  server_name = { "terraformls", "tflint" },
  setup = function(on_attach)
    local lspconfig = require("lspconfig")

    lspconfig["terraformls"].setup({
      on_attach = on_attach
    })

    lspconfig["tflint"].setup({
      on_attach = on_attach
    })
  end,
}
