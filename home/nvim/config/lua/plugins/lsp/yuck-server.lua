return {
  setup = function(on_attach)
    local lspconfig = require("lspconfig")
    local configs = require("lspconfig.configs")

    if not configs.yuck_ls then
      configs.yuck_ls = {
        default_config = {
          cmd = { 'YuckLS' },
          filetypes = { 'yuck' },
          root_dir = function()
            return vim.fn.getcwd()
          end,
          settings = {},
        },
      }
    end

    lspconfig.yuck_ls.setup({
      on_attach = function(client, bufnr)
        print("Yuck server attached")
        on_attach(client, bufnr)
      end,
    })
  end
}
