return {
  dependencies = {
    {
      "nvim-java/nvim-java",
    },
  },
  server_name = "",
  setup = function(on_attach)
    require("java").setup()

    -- Custom on_attach function for Java that disables LSP formatting
    local java_on_attach = function(client, bufnr)
      -- Disable LSP formatting for Java files (we'll use google-java-format instead)
      -- client.server_capabilities.documentFormattingProvider = false
      -- client.server_capabilities.documentRangeFormattingProvider = false

      -- Call the standard on_attach function
      on_attach(client, bufnr)

      -- Set up google-java-format on save for Java files
      -- vim.cmd([[
      --   augroup JavaFormat
      --     autocmd! * <buffer>
      --     autocmd BufWritePre <buffer> silent! !google-java-format --replace %
      --   augroup END
      -- ]])
    end

    require("lspconfig")["jdtls"].setup({
      on_attach = java_on_attach,
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
