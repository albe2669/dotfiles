local C = {
  setup = function (on_attach)
    require("clangd_extensions").setup({
      server = {
        on_attach = on_attach,
      },
    })
  end,
}

return C
