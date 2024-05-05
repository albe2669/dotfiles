return {
  server_name = "clangd",
  dependencies = {
    {
      "p00f/clangd_extensions.nvim",
    }
  },
  setup = function (on_attach)
    require("clangd_extensions").setup({
      server = {
        on_attach = on_attach,
      },
    })
  end,
}
