return {
  server_name = "tailwindcss",
  setup = function(on_attach)
    local lspconfig = require("lspconfig")

    lspconfig["tailwindcss"].setup({
      on_attach = on_attach,
    })
  end
}
