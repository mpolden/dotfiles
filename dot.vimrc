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
set number

" better smartident
filetype plugin indent on

" enable syntax highlighting
syntax on

" color scheme
colorscheme mustang
set background=dark

" always show the status line as the second last line
set laststatus=2

" status line
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

" toggle paste mode
set pastetoggle=<F10>

" disable arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" disable home, end, pageup, pagedown
map <home> <nop>
map <end> <nop>
map <pageup> <nop>
map <pagedown> <nop>
imap <home> <nop>
imap <end> <nop>
imap <pageup> <nop>
imap <pagedown> <nop>

" disable visual and audible bell
set vb t_vb=

" show column marker
if exists('+colorcolumn')
    set colorcolumn=80
    highlight ColorColumn ctermbg=235
endif
