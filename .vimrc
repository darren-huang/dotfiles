" -------- Plugins ------------------------------------------------------

" vim-plug stuff
call plug#begin('~/.vim/plugged')
Plug 'vim-scripts/c.vim'
Plug 'preservim/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'frazrepo/vim-rainbow'
Plug 'dracula/vim', { 'as': 'dracula' }
call plug#end()

" -------- Visuals ------------------------------------------------------

" lightlihgt stuff
set laststatus=2
let g:lightline = {'colorscheme': 'dracula'}
if !has('gui_running')
  set t_Co=256
endif
set noshowmode

" dracula stuff
if (has("termguicolors"))
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif
colorscheme dracula
let g:dracula_italic = 0

" -------- Vim Settings ----------------------------------------------------

set number
syntax enable " Syntax highlighting
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
set viminfo='100,f1

" Settings for paste mode
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>

" Settings for panel naviagation
map <C-J> <C-W>j
map <C-K> <C-W>k
nmap <C-H> <C-W>h
nmap <C-L> <C-W>l

