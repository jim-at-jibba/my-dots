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
" telescope requirements...
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
" Plug 'fhill2/telescope-ultisnips.nvim'

" Look and feel
" Plug 'mhartington/oceanic-next'
" Plug 'arcticicestudio/nord-vim'
Plug 'norcalli/nvim-colorizer.lua'
" Plug 'p00f/nvim-ts-rainbow'
Plug 'embark-theme/vim', { 'as': 'embark' }
Plug 'folke/tokyonight.nvim'
"Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'windwp/nvim-ts-autotag'
" Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}

" git
Plug 'jreybert/vimagit'
Plug 'junegunn/gv.vim'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
Plug 'f-person/git-blame.nvim'

" langs
" Plug 'fatih/vim-go'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'tjdevries/nlua.nvim'
Plug 'jparise/vim-graphql'
Plug 'euclidianAce/BetterLua.vim'
" Plug 'npxbr/glow.nvim', {'do': ':GlowInstall', 'branch': 'main'}


" utils
Plug 'mbbill/undotree'
Plug 'SirVer/ultisnips'
" Plug 'mlaursen/vim-react-snippets'
Plug 'honza/vim-snippets'
Plug 'cohama/lexima.vim'
Plug 'romgrk/barbar.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'TaDaa/vimade'
Plug 'justinmk/vim-sneak'
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim'
Plug 'folke/trouble.nvim'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
Plug 'hrsh7th/nvim-compe'
Plug 'vim-test/vim-test'
Plug 'szw/vim-maximizer'
Plug 'mattn/emmet-vim'
" Plug 'folke/which-key.nvim'
" Plug 'andymass/vim-matchup'
" Plug 'windwp/nvim-ts-autotag'
" Plug 'tzachar/compe-tabnine', { 'do': './install.sh' }

" TPOPE
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

" Me
Plug '~/dotfiles/nvim/lua/whid'
Plug 'jim-at-jibba/navy-vim'

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
nnoremap <leader>c :lclose<bar>b#<bar>bd #<CR>

" disable Arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Simpler mappings for switching
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


" NvimTree -----------------------------------------------------------------{{{
let g:nvim_tree_side = 'right'
let g:nvim_tree_width = 40 
let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ] 
let g:nvim_tree_gitignore = 1
let g:nvim_tree_lsp_diagnostics = 1
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
