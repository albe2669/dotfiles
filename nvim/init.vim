" Enable autocmd
autocmd!

" Always assume unicode
scriptencoding utf-8
set fileencoding=utf-8
set encoding=utf8

" Line endings
set fileformat=unix
set fileformats=unix

" Disable compatability mode
set nocompatible

" File line numbers
set number

" Enable syntax highlighting
syntax on
syntax enable

" Enable indenting
set autoindent
filetype indent on
filetype plugin indent on
" Set tabs to be 4 spaces
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab

" Show title of file
set title

" Highlight current line
set cursorline

" Disable audio beep
set visualbell

" Increase the undo limit
set history=1000

" Display confirm dialog when closing unsaved file
set confirm

" Show commands
set showcmd
set cmdheight=1

" Always show status line
set laststatus=2

" Disable this perhaps
set scrolloff=10

" Enable search highlighting
set hlsearch
" Ignores case when searching
set ignorecase
" Unless smart case detects smth
set smartcase

" When going back on line move up or down
set whichwrap+=<,>,h,l,[,]

" Set shell
" TODO: Set one for linux
if has('win32')
	set shell=powershell
  set shellcmdflag=-c
  set shellquote=\"
  set shellxquote=
else
  set shell=/bin/zsh
endif

" Imports
runtime ./plug.vim
runtime ./colors.vim

lua require("init")

