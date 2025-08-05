return {
  server_name = { "basedpyright", "ruff" },
  setup = function(on_attach)
    local lspconfig = require("lspconfig")

    lspconfig["basedpyright"].setup({
      on_attach = on_attach
    })
    lspconfig["ruff"].setup({
      on_attach = on_attach
    })
  end,
}
