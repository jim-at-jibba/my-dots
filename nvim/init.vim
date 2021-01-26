"     / __ )___  _____/ /___  _| |  / /  _/  |/  / __ \/ ____/
"    / __  / _ \/ ___/ __/ / / / | / // // /|_/ / /_/ / /
"   / /_/ /  __(__  ) /_/ /_/ /| |/ // // /  / / _, _/ /___
"  /_____/\___/____/\__/\__, / |___/___/_/  /_/_/ |_|\____/
"                      /____/
" Setup plug  ---------------------------------------------------------------{{{
call plug#begin('~/.local/share/nvim/plugged')

" Plug 'sheerun/vim-polyglot'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Look and feel
Plug 'arcticicestudio/nord-vim'
" Plug 'jim-at-jibba/ariake-vim-colors'
Plug 'mhartington/oceanic-next'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'norcalli/nvim-colorizer.lua'
Plug 'lukas-reineke/onedark.nvim'

" git
Plug 'jreybert/vimagit'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'mhinz/vim-signify'
Plug 'APZelos/blamer.nvim'

Plug 'tweekmonster/gofmt.vim'
Plug 'fatih/vim-go'


Plug 'mbbill/undotree'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'dense-analysis/ale'
Plug 'Raimondi/delimitMate'

Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

" telescope requirements...
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/telescope.nvim'

Plug 'romgrk/barbar.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'p00f/nvim-ts-rainbow'

Plug 'nathunsmitty/nvim-ale-diagnostic'

Plug 'TaDaa/vimade'

Plug 'puremourning/vimspector'

" Lua
Plug 'tjdevries/nlua.nvim'
Plug 'euclidianAce/BetterLua.vim'

Plug 'glepnir/galaxyline.nvim'

Plug 'justinmk/vim-sneak'

" Me
Plug '~/dotfiles/nvim/lua/whid'
Plug 'jim-at-jibba/navy-vim'

call plug#end()

" }}}

lua require('init')

" Mappings ---------------------------------------------------------------{{{
let mapleader = ' '

"make jj do esc"
inoremap jj <Esc>
" recording macros is not my thing
map q <Nop>

noremap H ^
noremap L g_

noremap <leader>kc :%bd<bar>e#<bar>bd#<CR>
" nnoremap <silent> <leader>q :lclose<bar>b#<bar>bd #<CR>

" nnoremap ; :

" disable Arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Simplier mappings for switching
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-L> <C-W><C-L>

" Align blocks of text and keep them selected
vmap < <gv
vmap > >gv

" NERDCommenter
  "vmap <C-/> <plug>NERDCommenterToggle
  "nmap <C-/> <plug>NERDCommenterToggle

nmap <silent> <leader>/ :nohlsearch<CR>

" Copy to system posteboard
vnoremap  <leader>y  "+y
nnoremap  <leader>y  "+y

nnoremap <leader>u :UndotreeToggle<CR>

" Move selected line
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap <leader>p "_dP

nnoremap <leader>+ :vertical resize +5<CR>
nnoremap <leader>- :vertical resize -5<CR>

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"}}}

" Golang -----------------------------------------------------------------{{{
" --- vim go (polyglot) settings.
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_variable_declarations = 1
let g:go_auto_sameids = 1

let g:gofmt_exe = 'goimports'
let g:go_doc_keywordprg_enabled = 0
"}}}

" SPLITS
" "Max out the height of the current split
" ctrl + w _
" Max out the width of the current split
" ctrl + w |
"
" Normalize all split sizes, which is very handy when resizing terminal
" ctrl + w =
"
" Next occurance of what ever is under your cursor
" *
" # to do the reverse
"
" Move to start and into insert
" shift + i
"
" ; to jump to the next on_exit
" , to jump to the previous
"
" ctrl+w + o close other buffers except on you are in
