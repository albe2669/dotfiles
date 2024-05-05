if has('win32')
		let g:plug_location = $HOME .  '/AppData/Local/nvim/plugged'
else
	let g:plug_location = $HOME . '/.local/share/nvim/plugged'
endif

" Plugins
call plug#begin(g:plug_location)
" To enable more of the features of rust-analyzer, such as inlay hints and more!
Plug 'simrat39/rust-tools.nvim'

" More clangd features
Plug 'p00f/clangd_extensions.nvim'

" COBOL
Plug 'Jorengarenar/COBOL.vim'

" Scala
Plug 'scalameta/nvim-metals'

" Cooklang
Plug 'luizribeiro/vim-cooklang', { 'for': 'cook' }

" Telescope fuzzy file finder
Plug 'nvim-lua/popup.nvim'

" Editor
Plug 'mg979/vim-visual-multi' " Multi cursor

" Other
Plug 'wakatime/vim-wakatime' " Timetracking
call plug#end()

