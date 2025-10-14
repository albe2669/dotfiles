return {
  server_name = { "tofu_ls" },
  setup = function(on_attach)
    vim.lsp.config("tofu_ls", {
      on_attach = on_attach
    })
  end,
}
