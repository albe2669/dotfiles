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
      filetypes = {
        "javascript",
        "typescript",
        "vue"
      },
      settings = {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        single_file_support = false,
        tsserver_plugins = {
          "@vue/typescript-plugin",
        },
      },
    })
  end
}
