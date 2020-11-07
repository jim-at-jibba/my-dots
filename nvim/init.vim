"     / __ )___  _____/ /___  _| |  / /  _/  |/  / __ \/ ____/
"    / __  / _ \/ ___/ __/ / / / | / // // /|_/ / /_/ / /
"   / /_/ /  __(__  ) /_/ /_/ /| |/ // // /  / / _, _/ /___
"  /_____/\___/____/\__/\__, / |___/___/_/  /_/_/ |_|\____/
"                      /____/
" Setup plug  ---------------------------------------------------------------{{{

call plug#begin('~/.local/share/nvim/plugged')

Plug 'sheerun/vim-polyglot'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Look and feel
Plug 'arcticicestudio/nord-vim'
" Plug 'jim-at-jibba/ariake-vim-colors'
Plug 'luochen1990/rainbow'
Plug 'mhartington/oceanic-next'

" git
Plug 'jreybert/vimagit'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

Plug 'tweekmonster/gofmt.vim'

"nerdtree
Plug 'scrooloose/nerdtree'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'

Plug 'vuciv/vim-bujo'
Plug 'mbbill/undotree'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'dense-analysis/ale'
Plug 'Raimondi/delimitMate'

" telescope requirements...
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/telescope.nvim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

" }}}


" System Settings  ----------------------------------------------------------{{{
  set termguicolors
  set nopaste
  set number
  set tabstop=2 shiftwidth=2 expandtab
  let mapleader = ' '
  set spell
  set splitbelow
  set splitright
  set relativenumber
  set scrolloff=5
  set completeopt=menuone,noinsert,noselect
  set signcolumn=yes

  set backupdir=~/.vim/.backup//
  set directory=~/.vim/.swp//


  if has("persistent_undo")
      set undodir="~/.vim/.undodir"
      set undofile
  endif
"}}}

" System mappings  ----------------------------------------------------------{{{

  "make jj do esc"
  inoremap jj <Esc>
  " recording macros is not my thing
  map q <Nop>

  noremap H ^
  noremap L g_
  noremap J 5j
  noremap K 5k

  noremap <leader>kc :%bd<bar>e#<bar>bd#<CR>
  nnoremap <silent> <leader>q :lclose<bar>b#<bar>bd #<CR>

  nnoremap ; :

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
  " vmap <C-/> <plug>NERDCommenterToggle
  " nmap <C-/> <plug>NERDCommenterToggle

  nmap <silent> <leader>/ :nohlsearch<CR>

  " Copy to system posteboard
  vnoremap  <leader>y  "+y
  nnoremap  <leader>y  "+y

  nnoremap <leader>u :UndotreeToggle<CR>

  vnoremap <leader>p "_dP

  nnoremap <Leader>+ :vertical resize +5<CR>
  nnoremap <Leader>- :vertical resize -5<CR>

  " Use <Tab> and <S-Tab> to navigate through popup menu
  inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"}}}

" Themes, Commands, etc  ----------------------------------------------------{{{
  if (has("termguicolors"))
    set termguicolors
  endif

  if !exists('g:syntax_on')
    syntax enable
  endif

  set t_Co=256
  set background=dark
  let g:oceanic_next_terminal_bold = 1
  let g:oceanic_next_terminal_italic = 1
  colorscheme oceanicnext

"}}}


" NERDTree ---------------------------------------------------------------{{{
  let NERDTreeIgnore = ['\.DS_Store']
  let NERDTreeRespectWildIgnore=1
  map <leader><leader>1 :NERDTreeToggle<CR>
  let NERDTreeShowHidden=1
  let NERDTreeHijackNetrw=0
  let g:NERDTreeWinSize=45
  let g:NERDTreeAutoDeleteBuffer=1
  let NERDTreeMinimalUI=1
  let NERDTreeCascadeSingleChildDir=1
  let g:NERDTreeHeader = 'hello'
" }}}

" LSP ------------------------------------------------------------- {{{
" Show diagnostic on hover
autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()

nnoremap <leader>dd :lua vim.lsp.buf.definition()<CR>
nnoremap <leader>d :lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>vsh :lua vim.lsp.buf.signature_help()<CR>

" nnoremap <leader>dr :lua vim.lsp.buf.references()<CR>
nnoremap <leader>rn :lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>gh :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>ca :lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>sd :lua vim.lsp.util.show_line_diagnostics()<CR>


let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_enable_snippet = 'UltiSnips'
let g:completion_enable_auto_signature = 1
let g:completion_enable_auto_paren = 1

lua require'nvim_lsp'.tsserver.setup{ on_attach=require'completion'.on_attach }
 lua require'nvim_lsp'.gopls.setup{ on_attach=require'completion'.on_attach }

" }}}

" FZF --------------------------------------------------------------------{{{

  let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8}}
  if !&diff
    nnoremap <silent> <C-p> :Files<Cr>
    nnoremap <silent> <Leader>g :GFiles?<CR>
    nnoremap <silent> <Leader>c  :Commits<CR>
    nnoremap <silent> <Leader>bc :BCommits<CR>
  endif
"}}}

" Random --------------------------------------------------------------------{{{

let g:NERDCreateDefaultMappings = 0

" if strftime("%H") < 17
"   set background=light
" else
"   set background=dark
" endif

  " Sweet Sweet FuGITive
  " nmap <leader>gh :diffget //3<CR>
  " nmap <leader>gu :diffget //2<CR>
nmap <leader>gs :G<CR>

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
"}}}

" Telescope -----------------------------------------------------------------{{{
let g:telescope_cache_results = 1
let g:telescope_prime_fuzzy_find  = 1

nnoremap <leader>pw :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
nnoremap <leader>b :lua require('telescope.builtin').buffers({show_all_buffers = true})<CR>
" nnoremap <leader>f :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For >")})<CR>
nnoremap <leader>f :lua require('telescope.builtin').live_grep()<CR>
nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>
nnoremap <Leader>pf :lua require('telescope.builtin').find_files()<CR>
nnoremap <Leader>dr :lua require('telescope.builtin').lsp_references()<CR>

"}}}

" Todo -----------------------------------------------------------------{{{
nmap <Leader>tu <Plug>BujoChecknormal
nmap <Leader>th <Plug>BujoAddnormal
let g:bujo#todo_file_path = $HOME . "/.cache/bujo"
"}}}

" Go -----------------------------------------------------------------{{{

let g:gofmt_exe = 'goimports'

"}}}

" Ale -----------------------------------------------------------------{{{
nmap <silent> <leader> [g <Plug>(ale_previous_wrap)
nmap <silent> <leader>]g <Plug>(ale_next_wrap)

let g:ale_linters = {
\   'javascript': ['eslint'],
\   'javascriptreact': ['eslint'],
\   'typescript': ['eslint', 'tslint'],
\   'typescriptreact': ['eslint', 'tslint'],
\   'go': ['golint'],
\}

let g:ale_fixers = {
\   'javascript': ['prettier', 'eslint'],
\   'javascriptreact': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\   'typescriptreact': ['prettier', 'eslint'],
\   'go': ['gofmt'],
\   'css': ['prettier'],
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\}
let g:ale_linters_explicit = 1
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1
let g:ale_sign_error = '💩'
let g:ale_sign_warning = '⚠️'
let g:ale_disable_lsp = 1
let g:ale_open_list = 0

"}}}

" Airline -----------------------------------------------------------------{{{

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#wordcount#enabled = 0
let g:airline_powerline_fonts = 1
let g:airline_symbols.branch = ''
let g:airline_theme='oceanicnext'
tmap <leader>1  <C-\><C-n><Plug>AirlineSelectTab1
tmap <leader>2  <C-\><C-n><Plug>AirlineSelectTab2
tmap <leader>3  <C-\><C-n><Plug>AirlineSelectTab3
tmap <leader>4  <C-\><C-n><Plug>AirlineSelectTab4
tmap <leader>5  <C-\><C-n><Plug>AirlineSelectTab5
tmap <leader>6  <C-\><C-n><Plug>AirlineSelectTab6
tmap <leader>7  <C-\><C-n><Plug>AirlineSelectTab7
tmap <leader>8  <C-\><C-n><Plug>AirlineSelectTab8
tmap <leader>9  <C-\><C-n><Plug>AirlineSelectTab9
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab

"}}}
let g:rainbow_active = 1
let g:rainbow_conf = {
  \    'separately': {
  \       'nerdtree': 0
  \    }
  \}

" === coc.nvim === "
" nmap <silent> <leader>dd <Plug>(coc-definition)
" nmap <silent> <leader>dy <Plug>(coc-type-definition)
" nmap <silent> <leader>dr <Plug>(coc-references)
" nmap <silent> <leader>dj <Plug>(coc-implementation)
" nnoremap <silent> <leader>gh :call <SID>show_documentation()<CR>
"
" ctrl+y - select contents of popup
" ctr+r " - paste visual selection
" * - search for word under cursor in file
" <leader>y copy text to system keyboard

" === FZF === "
" nnoremap <silent> <leader>e :call Fzf_dev()<CR>
" nnoremap <silent> <Leader>g :GFiles?
" nnoremap <silent> <Leader>c  :Commits<CR>
" nnoremap <silent> <Leader>bc :BCommits<CR>
" <leader>enter - list open buffers
" C-w-w to jump into the pop up
"
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
" f (char) to jump to a characters
" t to jump to the char before
" ; to jump to the next on_exit
" , to jump to the previous
"
" ctrl+w + o close other buffers except on you are in
