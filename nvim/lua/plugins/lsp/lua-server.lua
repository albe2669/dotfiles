local L = {
  setup = function(on_attach)
    local lspconfig = require("lspconfig")

    lspconfig["sumneko_lua"].setup({
      on_attach = on_attach,
      settings = {
        Lua = {
          telemetry = {
            enable = false,
          },
        },
      },
    })
  end
}

return L
