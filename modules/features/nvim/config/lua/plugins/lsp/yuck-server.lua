return {
  setup = function(on_attach)
    vim.lsp.config("yuck_ls", {
      cmd = { 'YuckLS' },
      filetypes = { 'yuck' },
      root_dir = function()
        return vim.fn.getcwd()
      end,
      settings = {},
      on_attach = function(client, bufnr)
        print("Yuck server attached")
        on_attach(client, bufnr)
      end,
    })
  end
}
