" Panel Naviagation
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-H> <C-W>h
nmap <C-L> <C-W>l
" Panel Splitting
nmap <C-W>r <C-W>v<C-W>l
nmap <C-W>d <C-W>s<C-W>j
" Panel Resizing
nmap <F12> <C-W>4>
nmap <F11> <C-W>4<
nmap <F10> <C-W>+
nmap <F9> <C-W>-
nmap <C-E> <C-W>=
nmap <C-F> <C-W>_<C-W>\|

" Settings for paste mode
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>

" NERDTree
nmap <C-n> :NERDTreeToggle<CR>

" ALE
nmap <F3> :ALEToggle<CR>

" Git-Gutter
nmap <F4> :GitGutterToggle<CR>

" StartifySave
nmap <F5> :SSave!<CR>
