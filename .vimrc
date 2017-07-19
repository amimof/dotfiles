" An example for a vimrc file.

" Show line numbers
set number
highlight LineNr ctermfg=grey ctermbg=black

set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set nowrap      " Disable text wrapping
set nostartofline " Do not start on first none blank char on the line

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("GUI_running")
    syntax on
    set hlsearch
endif
