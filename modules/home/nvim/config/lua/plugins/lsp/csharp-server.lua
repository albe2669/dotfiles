return {
  -- server_name = "roslyn",
  dependencies = {
    {
      "seblyng/roslyn.nvim",
      ft = "cs",
      ---@module 'roslyn.config'
      ---@type RoslynNvimConfig
      opts = {
        -- your configuration comes here; leave empty for default settings
      },
    }
  },
  setup = function(on_attach)
    print("C# server setup called")

    vim.lsp.config("roslyn", {
      on_attach = on_attach,
    })
  end,
}
