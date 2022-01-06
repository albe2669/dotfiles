" Prevent crashes when using nerdtree
let g:plug_window = 'noautocmd vertical topleft new'

" Start nerdtree on startup
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p

" When entering directory set nerdtree root
let g:NERDTreeChDirMode = 2

