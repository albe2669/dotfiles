" ===============
" THEME SETTINGS
" ===============
" let g:horizon_transparent_bg=1
let g:everforest_better_performance=1
let g:everforest_background='hard'
let g:everforest_transparent_background=1
let g:everforest_enable_italic=1
let g:everforest_spell_foreground='colored'
let g:everforest_diagnostic_text_highlight=1 " If errors/info/warning looks strange, this highlights background
let g:everforest_diagnostic_line_highlight=1 " If errors/info/warning looks strange, this highlights the line
let g:everforest_diagnostic_virtual_text='grey'


" ================
" GLOBAL SETTINGS
" ================
" Use truecolor
if has('termguicolors')
  set termguicolors
endif

" Use colors that favor dark backgrounds
set background=dark

" Transparency
hi Normal ctermfg=255 ctermbg=NONE guifg=#ffffff guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Terminal ctermfg=255 ctermbg=NONE guifg=#ffffff guibg=NONE guisp=NONE cterm=NONE gui=NONE

" TODO: Help
hi Todo cterm=bold gui=bold ctermbg=None ctermfg=LightGreen guibg=None guifg=#9f3e85


" ============
" COLORSCHEME
" ============
" colorscheme horizon
" colorscheme gruvbox
colorscheme everforest

