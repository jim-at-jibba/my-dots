set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugins
"""""""""""""""""""""""""""""""""""""
Plugin 'scrooloose/nerdtree'
Plugin 'airblade/vim-gitgutter'
Plugin 'Chiel92/vim-autoformat'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'altercation/vim-colors-solarized'
Plugin 'ajh17/Spacegray.vim'
Plugin 'kristijanhusak/vim-hybrid-material'
Plugin 'duythinht/inori'
Plugin 'romainl/flattened'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'jnurmine/Zenburn'
Plugin 'pangloss/vim-javascript'
Plugin 'tpope/vim-markdown'
Plugin 'othree/html5.vim'
Plugin 'elzr/vim-json'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'tpope/vim-fugitive'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal

" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Toggle nerdtree with F10
map <F10> :NERDTreeToggle<CR>
" Current file in nerdtree
map <F9> :NERDTreeFind<CR>

" autoformat
noremap <F3> :Autoformat<CR>

" CtrlP Settigns
""""""""""""""""""""""""
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard'] " Ignored files in git ignore

" Airline setting
""""""""""""""""""""""""
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
   let g:airline_symbols = {}
   endif
let g:airline_symbols.space = "\ua0"
let g:airline_theme='luna'
set t_Co=256

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" hides bufferline from statusline
let g:bufferline_echo = 0

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
 
" Basic settings
"""""""""""""""""""""""""""""

set nocompatible                " choose no compatibility with legacy vi
syntax enable
set encoding=utf-8
set showcmd                     " display incomplete commands
set number                      " Show line numbers
set ruler                       " show the cursor position all the time
set timeoutlen=50               " avoids delay in switching to normal from insert - turned off to allow jj binding to escape 

""Theme
let g:enable_bold_font = 1
set encoding=utf8
colorscheme zenburn
 "set background=light

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode
let mapleader = ','

set smartcase
set ignorecase
set noantialias
set laststatus=2

" Mappings
""""""""""""""""""""""""""""
nnoremap <leader>ev :tabedit $MYVIMRC<cr>


" Auto-Command
"""""""""""""""""""""""""""
" Automatically source vimrc file on save
autocmd BufWritePost .vimrc source %
