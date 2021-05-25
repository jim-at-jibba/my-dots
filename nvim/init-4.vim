"     / __ )___  _____/ /___  _| |  / /  _/  |/  / __ \/ ____/
"    / __  / _ \/ ___/ __/ / / / | / // // /|_/ / /_/ / /
"   / /_/ /  __(__  ) /_/ /_/ /| |/ // // /  / / _, _/ /___
"  /_____/\___/____/\__/\__, / |___/___/_/  /_/_/ |_|\____/
"                      /____/
" Setup plug  ---------------------------------------------------------------{{{
if exists('g:vscode')
    " VSCode extension
else
  call plug#begin('~/.local/share/nvim/plugged')

  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'

  " Look and feel
  Plug 'mhartington/oceanic-next'
  Plug 'romainl/flattened'
  Plug 'norcalli/nvim-colorizer.lua'
  Plug 'sheerun/vim-polyglot'
  " Plug 'vim-airline/vim-airline'
  " Plug 'vim-airline/vim-airline-themes'
  " Plug 'ryanoasis/vim-devicons'

  " git
  Plug 'jreybert/vimagit'
  Plug 'junegunn/gv.vim'

  " utils
  Plug 'mbbill/undotree'
  Plug 'cohama/lexima.vim'
  Plug 'TaDaa/vimade'
  Plug 'justinmk/vim-sneak'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'preservim/nerdtree'
  Plug 'ap/vim-buftabline'

  " Javascript
  Plug 'pangloss/vim-javascript'
  Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
  Plug 'jparise/vim-graphql'

  " Coc
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'antoinemadec/coc-fzf'

  call plug#end()
endif
" }}}

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
