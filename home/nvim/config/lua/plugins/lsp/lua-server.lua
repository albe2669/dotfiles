local L = {
  setup = function(on_attach)
    local lspconfig = require("lspconfig")

    lspconfig["lua_ls"].setup({
      on_attach = on_attach,
      settings = {
        Lua = {
          telemetry = {
            enable = false,
          },
          runtime = {
            version = 'LuaJIT',
          },
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
          },
        },
      },
    })
  end
}

return L
