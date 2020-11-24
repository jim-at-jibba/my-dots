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
Plug 'mhartington/oceanic-next'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'norcalli/nvim-colorizer.lua'

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

Plug 'nvim-treesitter/nvim-treesitter'

Plug 'nathunsmitty/nvim-ale-diagnostic'

Plug 'TaDaa/vimade'

" Lua
Plug 'tjdevries/nlua.nvim'
Plug 'euclidianAce/BetterLua.vim'

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
  set updatetime=100

  " Fold stuff
  set nofoldenable
  set foldlevel=99
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()

  set nobackup
  set nowritebackup
  set noswapfile


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
  " nnoremap J 5j
  " nnoremap K 5k

  noremap <leader>kc :%bd<bar>e#<bar>bd#<CR>
  " nnoremap <silent> <leader>q :lclose<bar>b#<bar>bd #<CR>

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

  lua require'colorizer'.setup()

  if !exists('g:syntax_on')
    syntax enable
  endif

  " Should this be in ~/.config
  let color_path = expand('~/dotfiles/nvim/color.vim')

  if filereadable(color_path)
    exec 'source' color_path
  else
    set background=dark
    colorscheme ariake
  endif


  set t_Co=256
"}}}


" Nvim-tree ---------------------------------------------------------------{{{
let g:lua_tree_ignore = [ '.git', 'node_modules', '.cache' ]
let g:lua_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
let g:lua_tree_show_icons = {
    \ 'git': 1,
    \ 'folders': 1,
    \ 'files': 1,
    \ }
" NOTE: the 'edit' key will wrap/unwrap a folder and open a file
let g:lua_tree_bindings = {
    \ 'edit':            ['<CR>', 'o'],
    \ 'edit_vsplit':     '<C-v>',
    \ 'edit_split':      '<C-x>',
    \ 'edit_tab':        '<C-t>',
    \ 'toggle_ignored':  'I',
    \ 'toggle_dotfiles': 'H',
    \ 'refresh':         'R',
    \ 'preview':         '<Tab>',
    \ 'cd':              '<C-]>',
    \ 'create':          'a',
    \ 'remove':          'd',
    \ 'rename':          'r',
    \ 'cut':             'x',
    \ 'copy':            'c',
    \ 'paste':           'p',
    \ 'prev_git_item':   '[c',
    \ 'next_git_item':   ']c',
    \ }

" Disable default mappings by plugin
" Bindings are enable by default, disabled on any non-zero value
" let lua_tree_disable_keybindings=1

" default will show icon by default if no icon is provided
" default shows no icon by default
let g:lua_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': "★"
    \   },
    \ 'folder': {
    \   'default': "",
    \   'open': ""
    \   }
    \ }

nnoremap <leader><leader>1 :LuaTreeToggle<CR>
nnoremap <leader>r :LuaTreeRefresh<CR>
nnoremap <leader>n :LuaTreeFindFile<CR>


" }}}

" LSP ------------------------------------------------------------- {{{
lua require("my_lspconfig")

" nnoremap <leader>dd :lua vim.lsp.buf.definition()<CR>
" nnoremap <leader>d :lua vim.lsp.buf.implementation()<CR>
" nnoremap <leader>vsh :lua vim.lsp.buf.signature_help()<CR>
"
" nnoremap <leader>dr :lua vim.lsp.buf.references()<CR>
" nnoremap <leader>rn :lua vim.lsp.buf.rename()<CR>
" nnoremap <silent> <leader>gh :lua vim.lsp.buf.hover()<CR>
" nnoremap <leader>ca :lua vim.lsp.buf.code_action()<CR>
" nnoremap <silent> <leader>sd :lua vim.lsp.util.show_line_diagnostics()<CR>
"
"
" lua require'lspconfig'.tsserver.setup{}
" lua require'lspconfig'.gopls.setup{}
"
" autocmd BufEnter * lua require'completion'.on_attach()
" autocmd BufEnter * set omnifunc=v:lua.vim.lsp.omnifunc
"
"
" " Diagnostics
"
" lua << EOF
" vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
"   vim.lsp.diagnostic.on_publish_diagnostics, {
"     virtual_text = true,
"     signs = true,
"     update_in_insert = false,
"   }
" )
" EOF

" let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
nnoremap <leader>dn :lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <leader>dp :lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <leader>dl :lua vim.lsp.diagnostic.set_loclist()<CR>

"let g:completion_enable_snippet = 'UltiSnips'
"let g:completion_enable_auto_signature = 1
"let g:completion_enable_auto_paren = 1

" trigger autocomplete in insert mode
inoremap <c-space> <c-x><c-o>


let g:UltiSnipsSnippetDirectories=["Ultisnips", "mysnippets"]


" }}}

" FZF --------------------------------------------------------------------{{{

  let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8}}
  if !&diff
    " nnoremap <silent> <C-p> :Files<Cr>
   nnoremap <silent> <Leader>g :GFiles?<CR>
   " nnoremap <silent> <Leader>c  :Commits<CR>
   " nnoremap <silent> <Leader>bc :BCommits<CR>
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
nnoremap <Leader>ol :lua require('telescope.builtin').loclist()<CR>
" nnoremap <Leader>g :lua require('telescope.builtin').git_status()<CR>
nnoremap <Leader>c :lua require('telescope.builtin').git_commits()<CR>
nnoremap <Leader>bc :lua require('telescope.builtin').git_bcommits()<CR>
nnoremap <Leader>cR :lua require('telescope.builtin').reloader()<CR>

nnoremap <Leader>ca :lua require('telescope.builtin').lsp_code_actions()<CR>

lua << EOF
require('telescope').setup{
  defaults = {
    prompt_prefix = "🦄 ",
  }
}

EOF

"}}}

" Go -----------------------------------------------------------------{{{

let g:gofmt_exe = 'goimports'
let g:go_doc_keywordprg_enabled = 0
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
\   'html': ['htmlhint'],
\}

let g:ale_fixers = {
\   'javascript': ['prettier', 'eslint'],
\   'javascriptreact': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\   'typescriptreact': ['prettier', 'eslint'],
\   'go': ['gofmt'],
\   'css': ['prettier'],
\   'html': ['prettier'],
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\}
let g:ale_linters_explicit = 1
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1
let g:ale_sign_error = '💩'
let g:ale_sign_warning = '📣 '
let g:ale_disable_lsp = 1
let g:ale_open_list = 0
let g:ale_virtualtext_cursor = 1

"}}}

" BarBar -----------------------------------------------------------------{{{
nnoremap <silent> <C-s> :BufferPick<CR>
nnoremap <silent>    <leader>1 :BufferGoto 1<CR>
nnoremap <silent>    <leader>2 :BufferGoto 2<CR>
nnoremap <silent>    <leader>3 :BufferGoto 3<CR>
nnoremap <silent>    <leader>4 :BufferGoto 4<CR>
nnoremap <silent>    <leader>5 :BufferGoto 5<CR>
nnoremap <silent>    <leader>6 :BufferGoto 6<CR>
nnoremap <silent>    <leader>7 :BufferGoto 7<CR>
nnoremap <silent>    <leader>8 :BufferGoto 8<CR>
nnoremap <silent>    <leader>9 :BufferLast<CR>
nnoremap <silent>    <leader>q :BufferClose<CR>

let bufferline = {}
let bufferline.animation = v:true
let bufferline.icons = v:true
let bufferline.closable = v:false
let bufferline.clickable = v:false
let bufferline.semantic_letters = v:true
let bufferline.letters =
  \ 'asdfjkl;ghnmxcbziowerutyqpASDFJKLGHNMXCBZIOWERUTYQP'
let bufferline.maximum_padding = 4

"}}}

" Git Gutter -----------------------------------------------------------------{{{
nmap <silent> <cr> <Plug>(signify-next-hunk)
nmap <silent> <backspace> <Plug>(signify-prev-hunk)
nmap <leader>gd :SignifyDiff<CR>

nmap <leader>gb :BlamerToggle<CR>
"}}}

"{{{ Treesitter -----------------------------------------------------------------{{{
lua << EOF

require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "c", "rust" },  -- list of language that will be disabled
  },
}

EOF
"}}}
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
