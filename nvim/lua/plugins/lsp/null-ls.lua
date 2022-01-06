local null_ls = require("null-ls")

local builtins = null_ls.builtins

local sources = {
    builtins.formatting.prettier,

    builtins.hover.dictionary,

    builtins.diagnostics.tsc,
}

local N = {
  setup = function(on_attach)
    null_ls.setup({
      sources = sources,
      on_attach = on_attach,
    })
  end
}

return N
