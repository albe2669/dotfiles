return {
  server_name = "lua_ls",
  setup = function(on_attach)
    vim.lsp.config("lua_ls", {
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
