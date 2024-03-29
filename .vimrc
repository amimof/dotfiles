set encoding=UTF-8
set nocompatible

" Semtingm
"set clipboard+=unnamedplus
syntax on                                                   " Enable syntax highlighting 
set termguicolors                                           " Enable full color support
set hlsearch                                                " Highlight text while searching
set paste
set number                                                  " Enable line numbers
set cursorline                                              " Display cursor position by highlighting current line
set laststatus=2                                            " Show status line 
set scrolloff=5                                             " Leave 5 lines of buffer when scrolling
set sidescrolloff=10                                        " Leave 10 characters of horizontal buffer when scrolling
set smartindent
set tabstop=4
set expandtab
set shiftwidth=4
set backspace=indent,eol,start                              " Make backspace work like in most other programs (http://vi.stackexchange.com/a/2163)
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab    " Use 2-space tabs for yaml

" Keybindings
nnoremap <C-k> :bprevious<CR>
nnoremap <C-j> :bnext<CR>
nnoremap <C-d> :bdelete<CR>
vnoremap <Enter> "+y<Esc>

" Setup the status line
"highlight StatusLine ctermbg=darkred
"set statusline=
"set statusline+=%#NormalColor#%{(mode()=='n')?'\ \ NORMAL\ ':''}
"set statusline+=%#InsertColor#%{(mode()=='i')?'\ \ INSERT\ ':''}
"set statusline+=%#ReplaceColor#%{(mode()=='R')?'\ \ REPLACE\ ':''}
"set statusline+=%#VisualColor#%{(mode()=='v')?'\ \ VISUAL\ ':''}
"set statusline+=%#VisualColor#%{(mode()=='V')?'\ \ VISUAL\ ':''}
"set statusline+=%#PmenuSel#
"set statusline+=%#LineNr#
"set statusline+=\ %f
"set statusline+=%m
"set statusline+=%=
"set statusline+=%#CursorColumn#
"set statusline+=\ %y
"set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
"set statusline+=\[%{&fileformat}\]
"set statusline+=\ %p%%
"set statusline+=\ %l:%c
"set statusline+=\ 

"hi User1 ctermbg=green ctermfg=red   guibg=green guifg=red
"hi User2 ctermbg=red   ctermfg=blue  guibg=red   guifg=blue
"hi User3 ctermbg=blue  ctermfg=green guibg=blue  guifg=green

" Add colors to statusline
"hi NormalColor guifg=Black guibg=Grey ctermbg=7 ctermfg=0
"hi InsertColor guifg=Black guibg=Cyan ctermbg=51 ctermfg=0
"hi ReplaceColor guifg=Black guibg=maroon1 ctermbg=165 ctermfg=0
"hi VisualColor guifg=Black guibg=Orange ctermbg=202 ctermfg=0

" Plugin section
call plug#begin('/Users/amir/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

call plug#end()

" Styling
colorscheme catppuccin_mocha 
let g:airline_theme = 'catppuccin_mocha'
