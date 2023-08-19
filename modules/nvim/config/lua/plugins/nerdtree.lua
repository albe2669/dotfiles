-- Prevent crash
vim.g.plug_window = "noautocmd vertical topleft new"

-- Set nerdtree root when entering directory
vim.g.NERDTreeChDirMode = 2

-- Start nerdtree on startup
vim.cmd("autocmd VimEnter * NERDTree")
vim.cmd("autocmd VimEnter * wincmd p")

