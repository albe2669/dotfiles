local u = require("utils")

print("test")
require("neogen").setup({
  enabled = true,
  ...
})

u.nmap("<C-e>", ":lua require('neogen').generate()<CR>")
