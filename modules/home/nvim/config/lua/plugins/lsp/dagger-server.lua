return {
  server_name = "dagger",
  setup = function (on_attach)
    vim.lsp.config("dagger", {
      cmd = { 'dagger', 'cuelsp' },
      filetypes = { 'cue' },
      root_markers = { 'cue.mod', '.git' },
      single_file_support = true,
      settings = {},
      on_attach = on_attach,
    })
  end,
}
