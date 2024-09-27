return {
  server_name = "ts_ls",
  dependencies = {
    {
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    }
  },
  setup = function(on_attach)
    local ts_tools = require("typescript-tools")

    ts_tools.setup({
      on_attach = on_attach,
    })
  end
}
