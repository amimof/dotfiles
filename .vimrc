set encoding=UTF-8

" Plugins
call plug#begin()
Plug 'tomasiser/vim-code-dark'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
call plug#end()

" Settings
set hlsearch                                                " Highlight text while searching
set number                                                  " Enable line numbers
set cursorline                                              " Display cursor position by highlighting current line
set laststatus=2                                            " Show status line 
set showtabline=2                                           " Show tabline at the top
set scrolloff=5                                             " Leave 5 lines of buffer when scrolling
set sidescrolloff=10                                        " Leave 10 characters of horizontal buffer when scrolling
set smartindent
set tabstop=4
set expandtab
set shiftwidth=4
set backspace=indent,eol,start                              " Make backspace work like in most other programs (http://vi.stackexchange.com/a/2163)
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab    " Use 2-space tabs for yaml

" Keybindings
nnoremap <C-p> :Files<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <C-k> :bprevious<CR>
nnoremap <C-j> :bnext<CR>
nnoremap <C-d> :bdelete<CR>

" Styling
syntax on                                                   " Enable syntax highlighting 
colorscheme codedark                                        " Use VSCode like theme
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': [ ['close'] ]
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ }
      \ }
