if has('win32')
		let g:plug_location = $HOME .  '/AppData/Local/nvim/plugged'
else
	let g:plug_location = $HOME . '/.local/share/nvim/plugged'
endif

" Plugins
call plug#begin(g:plug_location)
" Themes
" Plug 'gruvbox-community/gruvbox'
" Plug 'ntk148v/vim-horizon'
Plug 'sainnhe/everforest'

" Lua line
Plug 'nvim-lualine/lualine.nvim'

" Icons, used by lualine and cokeline
Plug 'kyazdani42/nvim-web-devicons'

" LSP installer
Plug 'williamboman/nvim-lsp-installer'

" LSP client
Plug 'neovim/nvim-lspconfig'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'

" Improve the LSP ui
" Plug 'glepnir/lspsaga.nvim'

" Completion framework
Plug 'hrsh7th/nvim-cmp'

" LSP completion source for nvim-cmp
Plug 'hrsh7th/cmp-nvim-lsp'

" Snippet completion source for nvim-cmp
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" Other usefull completion sources
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'

" To enable more of the features of rust-analyzer, such as inlay hints and more!
Plug 'simrat39/rust-tools.nvim'

" Http client
Plug 'NTBBloodbath/rest.nvim'

" Tree sitter, better language highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Telescope fuzzy file finder
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Popup terminal
Plug 'voldikss/vim-floaterm'

" Editor
Plug 'preservim/nerdtree' " File window
Plug 'windwp/nvim-autopairs' " Closing brackets
Plug 'airblade/vim-rooter' " Sets working directory to the nearest git project
Plug 'airblade/vim-gitgutter' " Shows deleted and edited lines on the side
Plug 'tpope/vim-surround' " Surrounds words or lines with brackets, quotes etc.
Plug 'mg979/vim-visual-multi' " Multi cursor

" Other
Plug 'wakatime/vim-wakatime' " Timetracking
Plug 'nathom/filetype.nvim' " Speed up startup time
Plug 'danymat/neogen' " Generate annotations
call plug#end()

