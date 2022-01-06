local u = require("utils")

-- Start lazygit in terminal when pressing F7
u.nmap("<F7>", ":FloatermNew --disposable lazygit<CR>")

vim.g.floaterm_autoclose = 1
