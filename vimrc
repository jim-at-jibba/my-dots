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
Plugin 'scrooloose/syntastic'                 " Syntax checking
Plugin 'tpope/vim-surround'
Plugin 'mxw/vim-jsx'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'easymotion/vim-easymotion'
Plugin 'gregsexton/matchtag'
Plugin 'heavenshell/vim-jsdoc'
Plugin 'sumpygump/php-documentor-vim'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'evidens/vim-twig'
Plugin 'rakr/vim-two-firewatch'
Plugin 'raimondi/delimitmate'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'csscomb/vim-csscomb.git'

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
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0

" vim-json
set conceallevel=0

" Vim Emmet
let g:user_emmet_leader_key='<c-d>'

let g:EditorConfig_exclude_patterns = ['fugitive://.*']
let g:EditorConfig_exclude_patterns = ['scp://.*']


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



"============[  BACKUP SETTINGS  ]========="
"set nobackup
"set nowritebackup
set backupcopy=yes
set backupdir=~/.vimbackups/.backups//
set directory=~/.vimbackups/.swp//
set undodir=~/.vimbackups/.undo//





"==============[  Airline setting ] ==========="
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
   let g:airline_symbols = {}
   endif
let g:airline_symbols.space = "\ua0"
let g:airline_theme='twofirewatch'

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" hides bufferline from statusline
let g:bufferline_echo = 0

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch




"==============[  Syntastic  ]==============="
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_balloons = 1
let g:syntastic_enable_signs = 1
let g:CSSLint_FileTypeList = ['css', 'less', 'sess']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_php_checkers = ['php', 'phpmd']
let g:syntastic_css_csslint_args="--ignore=unique-headings,qualified-headings,adjoining-classes,universal-selector,floats,important,box-model"
"let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
let syntastic_mode_map = { 'passive_filetypes': ['html'] }
let g:syntastic_ignore_files = ['.sqg$']
let g:syntastic_html_tidy_exec = 'tidy5'

let g:syntastic_error_symbol = '❌'
let g:syntastic_style_error_symbol = '⁉️'
let g:syntastic_warning_symbol = '⚠️'
let g:syntastic_style_warning_symbol = '💩'

highlight link SyntasticError SpellBad
highlight link SyntasticWarning SpellCap


"SYNTASTIC SASS
let g:syntastic_scss_checkers = ['scss_lint']





"=================[  CSSComb  ]================"
" Map bc to run CSScomb. bc stands for beautify css
autocmd FileType css noremap <buffer> <leader>bc :CSScomb<CR>
" Automatically comb your CSS on save
autocmd BufWritePre,FileWritePre *.css,*.less,*.scss,*.sass silent! :CSScomb





"==============[  Easy Motion  ]============="
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Bi-directional find motion
" Jump to anywhere you want with minimal keystrokes, with just one key
" binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-s)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-s2)

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1





"==============[ JS and PHP Doc  ]==========="
" JSDOC
au BufRead,BufNewFile *.js     inoremap <buffer> <C-d> :JsDoc<CR>

"PHP DOC
au BufRead,BufNewFile *.php     inoremap <buffer> <C-d> :call PhpDoc()<CR>
au BufRead,BufNewFile *.php     nnoremap <buffer> <C-d> :call PhpDoc()<CR>
au BufRead,BufNewFile *.php     vnoremap <buffer> <C-d> :call PhpDocRange()<CR>
au BufRead,BufNewFile *.inc     inoremap <buffer> <C-d> :call PhpDoc()<CR>
au BufRead,BufNewFile *.inc     nnoremap <buffer> <C-d> :call PhpDoc()<CR>
au BufRead,BufNewFile *.inc     vnoremap <buffer> <C-d> :call PhpDocRange()<CR>
au BufRead,BufNewFile *.module  inoremap <buffer> <C-d> :call PhpDoc()<CR>
au BufRead,BufNewFile *.module  nnoremap <buffer> <C-d> :call PhpDoc()<CR>
au BufRead,BufNewFile *.module  vnoremap <buffer> <C-d> :call PhpDocRange()<CR>
au BufRead,BufNewFile *.install inoremap <buffer> <C-d> :call PhpDoc()<CR>
au BufRead,BufNewFile *.install nnoremap <buffer> <C-d> :call PhpDoc()<CR>
au BufRead,BufNewFile *.install vnoremap <buffer> <C-d> :call PhpDocRange()<CR>



"==============[  Autocomplete  ]============"
let g:SuperTabDefaultCompletionType = "<c-n>"



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
set scrolloff=8
set undofile
set relativenumber

" Hides scrollbars
set guioptions-=r
set guioptions-=l
set guioptions-=R
set guioptions-=L

"Font
set guifont=Inconsolata-dz\ for\ Powerline:h15
"set macligatures
"set guifont=Fira\ Code:h15

set gdefault
set showmatch





"==============[  Theme Settings ] ==========="
"let g:enable_bold_font = 1
set encoding=utf8
set background=light " or light if you prefer the light version
let g:two_firewatch_italics=1
colo two-firewatch

set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert model
set copyindent

set smartcase
set ignorecase
set laststatus=2
highlight LineNr ctermbg=none
highlight SignColumn ctermbg=none
set autochdir





"==========[  Leader keybindings  ]==========
nnoremap <leader>i =i{
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)





"==============[  Search Settings ] ==========="

set hlsearch
set incsearch

" Greplace settings - using Ag for search
set grepprg=ag
let g:grep_cmd_opts = '--line-numbers --noheading'




"==============[  Mappings ] ==========="
nnoremap <leader>ev :tabedit $MYVIMRC<cr>
nmap <Leader>es :e ~/.vim/snippets/

" Add simple highlight removal
nnoremap <leader>c :nohl<CR>

" Save
inoremap <c-s> <ESC>:w<CR>
nnoremap <c-s> <ESC>:w<CR>

" remaps ;
nnoremap ; :

" Ctags
nnoremap <leader>f :tag<space>
set tags=./tags,tags;$HOME

" Swap double quotes for single quote in whole file
nmap <Leader>rdq :%s/\"\([^"]*\)\"/'\1'/g



"==============[  Framework-Specific ] ==========="
"nmap <leader>es :e server.js<CR> "Shortcut to open server js. This is just a reminder to add these kinds of shortcuts




"==============[  Auto-Commands ] ==========="
" Automatically source vimrc file on save
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC | AirlineRefresh
    autocmd BufWritePost $MYVIMRC AirlineRefresh
augroup END " }

" Save on losing focus
function! FocusLostWrite()
  execute '!normal wa'
endfunction
autocmd FocusLost * silent! wall

"Stuff to tidy5
" REMOVE WHITESPACE ON SAVE
 ":autocmd BufWritePost * :StripWhitespace
 let blacklist = ['md', 'markdown', 'mdown']
 :autocmd BufWritePost * if index(blacklist, &ft) < 0 | :StripWhitespace

"==============[  Notes and Tips ] ==========="
" - Press 'zz' to center current line
" - `Ctrl + ]` goes to method under cursor
" - `Ctrl + ^` - flip back to previous edit location
" - :Ag to search
" - :Gsearch to start search and replace
" - select lines to change then `:s/searchFor/replaceWith`
" - :set paste / :set nopaste allows pasting with good formatting.
" - open current file in `:! open %`
" - `shift + >` & `shift + <` - will move selected code in or out
" - `vat` - visual select all tags
" - `r` to refresh nerdtree window
