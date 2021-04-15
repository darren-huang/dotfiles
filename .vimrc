" -------- Plugins ------------------------------------------------------

" vim-plug stuff
call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'dense-analysis/ale'
Plug 'airblade/vim-gitgutter'
Plug 'mhinz/vim-startify'
call plug#end()

" -------- Visuals ------------------------------------------------------
" setup highlighting settings (for ALE + Dracula theme)
set t_Cs=

" lightlihgt stuff
set laststatus=2
let g:lightline = {
    \   'colorscheme': 'dracula', 
    \   'component_function': {'filename': 'FilenameForLightline'}
    \}
if !has('gui_running')
  set t_Co=256
endif
set noshowmode

" Show full path of filename
function! FilenameForLightline()
    return expand('%')
endfunction

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

