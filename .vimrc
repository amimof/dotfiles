set encoding=UTF-8

" Plugins
call plug#begin()
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tomasiser/vim-code-dark'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'wfxr/minimap.vim' " Requires code-minimap https://github.com/wfxr/code-minimap
call plug#end()

" Styling
set number " Enable line numbers
colorscheme codedark
let g:NERDTreeGitStatusConcealBrackets = 1 " default: 0

" Indentation
set smartindent
set tabstop=4
set expandtab
set shiftwidth=4
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab " Use 2-space tabs for yaml

" Keybindings
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O
