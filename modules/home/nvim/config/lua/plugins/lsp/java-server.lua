return {
  dependencies = {
    {
      "nvim-java/nvim-java",
    },
  },
  server_name = "",
  setup = function(on_attach)
    require("java").setup()

    require("lspconfig")["jdtls"].setup({
      on_attach = on_attach,
      settings = {
        java = {
          configuration = {
            runtimes = {
              {
                name = "JavaSE-17",
                path = "/etc/profiles/per-user/goose/bin/java",
                default = true,
              }
            }
          }
        }
      }
    })
  end
}
