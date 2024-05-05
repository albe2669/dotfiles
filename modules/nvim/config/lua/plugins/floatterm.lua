return {
  {
    "voldikss/vim-floaterm",
    config = function()
      local u = require("utils")

      -- Start lazygit in terminal when pressing F8
      u.nmap("<F8>", ":FloatermNew --disposable lazygit<CR>")
      u.nmap("<F5>", ":FloatermNew --disposable<CR>")

      u.nmap("<F6>", ":FloatermToggle<CR>")

      vim.g.floaterm_autoclose = 1
    end,
  },
}
