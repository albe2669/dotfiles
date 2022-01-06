local u = require("utils")

-- Start lazygit in terminal when pressing F7
u.nmap("<F7>", ":FloatermNew lazygit<CR>")

-- Ignore process exited message
-- vim.cmd("autocmd TermClose term://*lazygit execute 'bdelete! ' . expand('<abuf>')")
