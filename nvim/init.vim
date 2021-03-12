"     / __ )___  _____/ /___  _| |  / /  _/  |/  / __ \/ ____/
"    / __  / _ \/ ___/ __/ / / / | / // // /|_/ / /_/ / /
"   / /_/ /  __(__  ) /_/ /_/ /| |/ // // /  / / _, _/ /___
"  /_____/\___/____/\__/\__, / |___/___/_/  /_/_/ |_|\____/
"                      /____/
" Setup plug  ---------------------------------------------------------------{{{
call plug#begin('~/.local/share/nvim/plugged')

Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Look and feel
Plug 'mhartington/oceanic-next'
Plug 'sheerun/vim-polyglot'

" git
Plug 'jreybert/vimagit'

" langs
Plug 'tweekmonster/gofmt.vim'
Plug 'fatih/vim-go'

" utils
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'dense-analysis/ale'
Plug 'nathunsmitty/nvim-ale-diagnostic'
Plug 'cohama/lexima.vim'
Plug 'justinmk/vim-sneak'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'tpope/vim-commentary'
Plug 'preservim/nerdtree'
Plug 'ap/vim-buftabline'
Plug 'nvim-lua/lsp-status.nvim'


call plug#end()

" }}}

lua require('init')

" Mappings ---------------------------------------------------------------{{{
let mapleader = ' '

inoremap jj <Esc>
map q <Nop>

noremap H ^
noremap L g_

noremap <leader>kc :%bd<bar>e#<bar>bd#<CR>
nnoremap <silent> <leader>q :lclose<bar>b#<bar>bd #<CR>

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
" inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
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
