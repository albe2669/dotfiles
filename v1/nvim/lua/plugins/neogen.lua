local u = require("utils")

require("neogen").setup({
  enabled = true,
  ...
})

u.nmap("<C-e>", ":lua require('neogen').generate()<CR>")
