let g:dracula_italic = 0

packadd! dracula
syntax enable
colorscheme dracula
set number

syntax on " Syntax highlighting
set showmatch " Shows matching brackets
set ruler " Always shows location in file (line#)
set smarttab " Autotabs for certain code
set expandtab "enter spaces when tab is pressed
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4

set statusline+=%F " see the current file name
set ruler
set showcmd

nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode
