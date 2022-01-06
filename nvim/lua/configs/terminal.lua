local u = require("utils")

-- Start terminal in insert mode
vim.cmd("autocmd TermOpen * startinsert")

-- Disable line numbers
vim.cmd("autocmd TermOpen * setlocal nonumber norelativenumber")

-- Remap terminal escape
u.tmap("<ESC>", "<C-\\><C-n>")
