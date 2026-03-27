return {
  server_name = { "terraformls", "tflint" },
  setup = function(on_attach)
    vim.lsp.config("terraformls", {
      on_attach = on_attach
    })

    vim.lsp.config("tflint", {
      on_attach = on_attach
    })
  end,
}
