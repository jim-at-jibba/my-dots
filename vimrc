" Vundle
"""""""""""""""""""""""""""""
set nocompatible              " be iMproved, required
filetype off                  " required
 
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vi
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
 
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Plugins
"""""""""""""""""""""""""""""
Plugin 'tpope/vim-fugitive.git'
Plugin 'bling/vim-airline'
Plugin 'scrooloose/nerdtree'
Plugin 'pangloss/vim-javascript'
Plugin 'airblade/vim-gitgutter'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'mattn/emmet-vim'
Plugin 'kien/ctrlp.vim' 
Plugin 'Valloric/YouCompleteMe'
Plugin 'Raimondi/delimitMate'
Plugin 'Chiel92/vim-autoformat'
"Plugin 'chriskempson/base16-vim'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'othree/html5.vim'
"Plugin 'pangloss/vim-javascript'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'moll/vim-node'
Plugin 'elzr/vim-json'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'tpope/vim-markdown'
Plugin 'scrooloose/syntastic'
Plugin 'rizzatti/dash.vim'


" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


" Toggle nerdtree with F10
map <F10> :NERDTreeToggle<CR>
" Current file in nerdtree
map <F9> :NERDTreeFind<CR>

" emmet settings
let g:user_emmet_leader_key='<C-Z>'

" autofomat
noremap <F3> :Autoformat<CR>

" airline setting
""""""""""""""""""""""""
" Airline
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline_theme='powerlineish'
set t_Co=256

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" hides bufferline from statusline
let g:bufferline_echo = 0

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" Syntastic settings
"""""""""""""""""""""""
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
let g:Syntastic_html_checkers=['']


set smartcase
set ignorecase
set noantialias
set laststatus=2
 
" Basic settings
"""""""""""""""""""""""""""""

set nocompatible                " choose no compatibility with legacy vi
syntax enable
set encoding=utf-8
set showcmd                     " display incomplete commands
set number                      " Show line numbers
set ruler                       " show the cursor position all the time
"set timeoutlen=50               " avoids delay in switching to normal from insert - turned off to allow jj binding to escape 
""Theme
set encoding=utf8
colorscheme solarized


"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>
inoremap jj <Esc>

""sy navigation between splits. Instead of ctrl-w + j. Just ctrl-j
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
