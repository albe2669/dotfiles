local opts = {
  enabled = true,
  ...
}

return {
  {
    "danymat/neogen",
    config = function()
      require("neogen").setup(opts)

      local u = require("utils")
      u.nmap("<C-e>", ":lua require('neogen').generate()<CR>")
    end,
  },
}

