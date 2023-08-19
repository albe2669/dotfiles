local D = {
  setup = function (on_attach)
    local lspconfig = require 'lspconfig'
    local configs   = require 'lspconfig.configs'
    local util      = require 'lspconfig.util'

    if not configs.dagger then
      configs.dagger = {
        default_config = {
          cmd = { 'dagger', 'cuelsp' },
          filetypes = { 'cue' },
          root_dir = function(fname)
            return util.root_pattern( 'cue.mod', '.git' )( fname )
          end,
          single_file_support = true,
          settings = {}
        },
      }
    end
    lspconfig.dagger.setup {
      on_attach = on_attach,
    }
  end,
}

return D
