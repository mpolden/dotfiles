" no need for vi compability
set nocompatible

" don't allow inline modelines
set nomodeline

" don't wrap lines
set nowrap

" allow backspace to delete characters
set bs=2

" tabs have a width of 4
set softtabstop=4

" display tab characters with a width of 4
set tabstop=4

" indent lines by this width
set shiftwidth=4

" insert tabs as spaces
set expandtab

" numbered lines
if exists('+relativenumber')
    set relativenumber
    autocmd InsertEnter * :set number
    autocmd InsertLeave * :set relativenumber
    autocmd FocusLost * :set number
    autocmd FocusGained * :set relativenumber
else
    set number
endif

" vundle
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

" vundle bundles
Bundle 'kien/ctrlp.vim'
Bundle 'kchmck/vim-coffee-script'
Bundle 'vim-scripts/wombat256.vim'
Bundle 'Lokaltog/vim-powerline'
Bundle 'spolu/dwm.vim'
Bundle 'jnwhiteh/vim-golang'
Bundle 'scrooloose/syntastic'

" filetype detection and smart indent
filetype plugin indent on

" enable syntax highlighting
syntax on

" color scheme
colorscheme wombat256mod

" always show the status line as the second last line
set laststatus=2

" toggle paste mode
set pastetoggle=<F10>

" disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" disable home, end, pageup, pagedown
noremap <home> <nop>
noremap <end> <nop>
noremap <pageup> <nop>
noremap <pagedown> <nop>
inoremap <home> <nop>
inoremap <end> <nop>
inoremap <pageup> <nop>
inoremap <pagedown> <nop>

" map jj to escape
inoremap jj <Esc>

" map leader
let mapleader = ","

" reformat
noremap <leader>f gg=G

" disable visual and audible bell
set vb t_vb=

" set 256 colors
set t_Co=256

" show column marker (+option-name  Vim option that works.)
if exists('+colorcolumn')
    set colorcolumn=80
    highlight ColorColumn ctermbg=235
endif

" highlight matches
set hlsearch

" incremental searching
set incsearch

" case insensitive search (unless atlast one capital letter is given)
set ignorecase
set smartcase

" clear search highlights
noremap <silent><leader>/ :nohls<cr>

" ctags
set tags=tags

" buffer mappings
noremap <leader>n :bn<cr>
noremap <leader>p :bp<cr>
noremap <leader>l :ls<cr>

" syntastic + fish workaround
" https://github.com/scrooloose/syntastic/issues/202
set shell=/bin/bash

" hidden buffers
set hidden
