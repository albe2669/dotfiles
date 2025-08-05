return {
  server_name = "cmake",
  setup = function (on_attach)
    local lspconfig = require("lspconfig")

    lspconfig.cmake.setup({
      on_attach = on_attach,
    })
  end
}
