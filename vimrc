let mapleader=' '

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'





"==============[  Pluggins ] ==========="
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
Plugin 'rizzatti/dash.vim'
Plugin 'tpope/vim-vinegar.git'
Plugin 'rking/ag.vim'                         " Uses ag - the silver surfer
Plugin 'skwp/greplace.vim'                    " Search and replace
Plugin 'darthmall/vim-vue'
Plugin 'mattn/emmet-vim'


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
map <leader>1 :NERDTreeToggle<CR>
" Current file in nerdtree
map <F9> :NERDTreeFind<CR>
let NERDTreeHijackNetrw = 0

" autoformat
noremap <F3> :Autoformat<CR>

" vim-json
set conceallevel=0

" Vim Emmet
let g:user_emmet_leader_key='<c-d>'



"==============[  CtrlP Settings ] ==========="
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard'] " Ignored files in git ignore
let g:ctrlp_custom_ignore = 'node_modules\DS_Store\git'
let g:ctrlp_match_window = 'top,order:ttb,min:1,max:30,results:30'

" Mappings
nnoremap <c-R> :CtrlPBufTag<cr>         " Allows search for Methods in current file
nnoremap <leader>r :CtrlPMRUFiles<cr>

nnoremap <leader>p :CtrlP<cr>





"==============[  Airline setting ] ==========="
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
 
"diables scrollbars
set guioptions-=r
set guioptions-=l
set guioptions-=R
set guioptions-=L
"Font
"set guifont=droid\ sans\ mono\ for\ powerline:h12
set guifont=Sauce\ Code\ Powerline:h14

set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch



"==============[  Split Settings ] ==========="
set splitbelow
set splitright

" Simplier mappings for switching
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-L> <C-W><C-L>





"==============[  Basic Settings ] ==========="
syntax enable
set encoding=utf-8
set showcmd                     " display incomplete commands
set number                      " Show line numbers
set ruler                       " show the cursor position all the time




"==============[  Theme Settings ] ==========="
let g:enable_bold_font = 1
set encoding=utf8
colorscheme zenburn


set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode
set copyindent

set smartcase
set ignorecase
set noantialias
set laststatus=2
highlight LineNr ctermbg=none
highlight SignColumn ctermbg=none
set autochdir




"==============[  Search Settings ] ==========="

set hlsearch
set incsearch

" Greplace settings - using Ag for search
set grepprg=ag
let g:grep_cmd_opts = '--line-numbers --noheading'




"==============[  Mappings ] ==========="
nnoremap <leader>ev :tabedit $MYVIMRC<cr>

" Add simple highlight removal
nnoremap<leader><space> :nihlsearch

" Save
inoremap <c-s> <ESC>:w<CR>
nnoremap <c-s> <ESC>:w<CR>

" remaps ;
nnoremap ; :

" Simple highlight removal
nnoremap <leader><space> :nohlsearch<cr> 

" Ctags
nnoremap <leader>f :tag<space>





"==============[  Framework-Specific ] ==========="
nmap <leader>es :e server.js<CR> "Shortcut to open server js. This is just a reminder to add these kinds of shortcuts






"==============[  Auto-Commands ] ==========="
" Automatically source vimrc file on save
augroup autosourcing
  autocmd!
  autocmd BufWritePost .vimrc source %
augroup END





"==============[  Notes and Tips ] ==========="
" - Press 'zz' to center current line
" - `Ctrl + ]` goes to method under cursor
" - `Ctrl + ^` - flip back to previous edit location
" - :Ag to search
" - :Gsearch to start search and replace
" - select lines to change then `:s/searchFor/replaceWith`
" - :set paste / :set nopaste allows pasting with good formatting.
" - open current file in `:! open %`
