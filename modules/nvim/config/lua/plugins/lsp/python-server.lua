return {
  server_name = "pylsp",
  setup = function(on_attach)
    local lspconfig = require("lspconfig")

    lspconfig["pylsp"].setup({
      on_attach = on_attach
    })
  end,
}
