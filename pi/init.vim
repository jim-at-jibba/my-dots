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

" }}}

" Sets ---------------------------------------------------------------{{{
set exrc " allows for local vimrc in projects
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set nohlsearch
set nopaste
set number
set hidden
set noerrorbells
set spell
set splitbelow
set splitright
set relativenumber
set nu
set scrolloff=8
set completeopt=menu,menuone,noinsert,noselect
set signcolumn=yes
set updatetime=100
set incsearch
set noshowmode

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


" BufTabLine -------------------------------------------------------------{{{
let g:buftabline_numbers=2
let g:buftabline_show=1

nmap <leader>1 <Plug>BufTabLine.Go(1)
nmap <leader>2 <Plug>BufTabLine.Go(2)
nmap <leader>3 <Plug>BufTabLine.Go(3)
nmap <leader>4 <Plug>BufTabLine.Go(4)
nmap <leader>5 <Plug>BufTabLine.Go(5)
nmap <leader>6 <Plug>BufTabLine.Go(6)
nmap <leader>7 <Plug>BufTabLine.Go(7)
nmap <leader>8 <Plug>BufTabLine.Go(8)
nmap <leader>9 <Plug>BufTabLine.Go(9)
nmap <leader>0 <Plug>BufTabLine.Go(10)

" }}

" Coc -------------------------------------------------------------0{{{

  let g:coc_global_extensions = [
    \ 'coc-snippets',
    \ 'coc-tsserver',
    \ 'coc-eslint',
    \ 'coc-prettier',
    \ 'coc-json',
    \ 'coc-emmet',
    \ 'coc-lists',
    \ 'coc-json',
    \ 'coc-html',
    \ 'coc-dictionary',
    \ 'coc-git',
    \ 'coc-pyright',
    \ 'coc-highlight',
    \ 'coc-styled-components',
    \ 'coc-css',
    \ 'coc-html',
    \ 'coc-markdownlint',
    \ 'coc-go'
    \ ]

  inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  let g:coc_snippet_next = '<tab>'

  " Use <c-space> to trigger completion.
  inoremap <silent><expr> <c-space> coc#refresh()

  " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
  " Coc only does snippet and additional edit on confirm.
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  " Or use `complete_info` if your vim support it, like:
  " inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

  " Use `[g` and `]g` to navigate diagnostics
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " navigate git hunks
  nmap <silent> <cr> <Plug>(coc-git-nextchunk)
  nmap <silent> <backspace> <Plug>(coc-git-prevchunk)
  nmap <silent> <leader>hi <Plug>(coc-git-chunkinfo)

  nmap <silent> <leader>dd <Plug>(coc-definition)
  nmap <silent> <leader>dy <Plug>(coc-type-definition)
  nmap <silent> <leader>dr <Plug>(coc-references)
  nmap <silent> <leader>dj <Plug>(coc-implementation)
  nnoremap <silent> <leader>gh :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
      call CocActionAsync('doHover')
    else
      execute '!' . &keywordprg . " " . expand('<cword>')
    endif
  endfunction

  " Highlight symbol under cursor on CursorHold
  "autocmd CursorHold * silent call CocActionAsync('highlight')

  nnoremap <silent> <leader>co  :<C-u>CocList outline<cr>
  nnoremap <silent> <leader>cs  :<C-u>CocList -I symbols<cr>

  " remap do action of current line
  nmap <leader>ac  <Plug>(coc-codeaction)

  " List errors
  nnoremap <silent> <leader>cl  :<C-u>CocList diagnostics<cr>

  " list commands available in tsserver (and others)
  nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>

  " restart when tsserver gets wonky
  nnoremap <silent> <leader>cR  :<C-u>CocRestart<CR>

  " Apply AutoFix to problem on the current line.
  nmap <leader>qf  <Plug>(coc-fix-current)

  " Symbol renaming.
  nmap <leader>rn <Plug>(coc-rename)

  " Remap for do codeAction of selected region
  function! s:cocActionsOpenFromSelected(type) abort
    execute 'CocCommand actions.open ' . a:type
  endfunction

  xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
  nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@

  autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

" }}}


" Colors -------------------------------------------------------------{{{
if (has("termguicolors"))
  set termguicolors
endif

lua require'colorizer'.setup()

if !exists('g:syntax_on')
  syntax enable
endif

" Should this be in ~/.config
let color_path = expand('~/dotfiles/nvim/color.vim')

" set background=dark
colorscheme OceanicNext
" colorscheme flattened_light

set t_Co=256

" }}}


" Colors -------------------------------------------------------------{{{
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8, 'yoffset':0.5,'xoffset': 0.5, 'border': 'rounded'}}
inoremap <expr> <c-x><c-f> fzf#vim#complete("fd <Bar> xargs realpath --relative-to " . expand("%:h"))

if has('nvim')
  au! TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
  au! FileType fzf tunmap <buffer> <Esc>
endif

if !&diff
  nnoremap <silent> <C-p> :Files<Cr>
  nnoremap <leader>f :Rg<Cr>
  nnoremap <silent> <Leader>b :Buffers<CR>
  nnoremap <silent> <Leader>g :GFiles?<CR>
  nnoremap <silent> <Leader>c  :Commits<CR>
  nnoremap <silent> <Leader>bc :BCommits<CR>
endif
" }}}

" NERDTree ---------------------------------------------------------------{{{
  let NERDTreeIgnore = ['\.DS_Store']
  let NERDTreeRespectWildIgnore=1
  map <leader><leader>1 :NERDTreeToggle<CR>
  let NERDTreeShowHidden=1
  let NERDTreeHijackNetrw=0
  let g:NERDTreeWinSize=45
  let g:NERDTreeAutoDeleteBuffer=1
  let g:WebDevIconsOS = 'Darwin'
  let NERDTreeMinimalUI=1
  let NERDTreeCascadeSingleChildDir=1
  let g:NERDTreeHeader = 'hello'
" }}}


" Sneak ---------------------------------------------------------------{{{

let g:sneak#s_next = 1
let g:sneak#label = 1

map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
" }}}


" Sidebar---------------------------------------------------------------{{{
" https://sidneyliebrand.io/blog/creating-my-own-vim-statusline
let g:mode_colors = {
      \ 'n':  'StatusLineSection',
      \ 'v':  'StatusLineSectionV',
      \ '^V': 'StatusLineSectionV',
      \ 'i':  'StatusLineSectionI',
      \ 'c':  'StatusLineSectionC',
      \ 'r':  'StatusLineSectionR'
      \ }

fun! StatusLineRenderer()
  let hl = '%#' . get(g:mode_colors, tolower(mode()), g:mode_colors.n) . '#'
  return hl
        \ . (&modified ? ' + │' : '')
        \ . ' %{StatusLineFilename()}  %#StatusLine#%='
        \ . hl
        \ . '  %{StatusDiagnostic()} '
endfun

fun! StatusLineFilename()
  if (&ft ==? 'netrw') | return '*' | endif
  return substitute(expand('%'), '^' . getcwd() . '/\?', '', 'i')
endfun

fun! StatusDiagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, 'E' . info['error'])
  endif
  if get(info, 'warning', 0)
    call add(msgs, 'W' . info['warning'])
  endif
  return join(msgs, ' '). ' ' . get(g:, 'coc_status', '')
endfun

fun! <SID>StatusLineHighlights()
  hi StatusLine         ctermbg=8  guibg=#85b1df ctermfg=15 guifg=#cccccc
  hi StatusLineNC       ctermbg=0  guibg=#85b1df ctermfg=8  guifg=#999999
  hi StatusLineSection  ctermbg=8  guibg=#7ef1ea ctermfg=0  guifg=#333333
  hi StatusLineSectionV ctermbg=11 guibg=#e89dfc ctermfg=0  guifg=#000000
  hi StatusLineSectionI ctermbg=10 guibg=#48afa7 ctermfg=0  guifg=#000000
  hi StatusLineSectionC ctermbg=12 guibg=#7f7ce3 ctermfg=0  guifg=#000000
  hi StatusLineSectionR ctermbg=12 guibg=#ed3f45 ctermfg=0  guifg=#000000
endfun

call <SID>StatusLineHighlights()
" only set default statusline once on initial startup.
" ignored on subsequent 'so $MYVIMRC' calls to prevent
" active buffer statusline from being 'blurred'.
if has('vim_starting')
  let &statusline = ' %{StatusLineFilename()}%=  %{StatusDiagnostic()} '
endif
augroup vimrc
  au!
  " show focussed buffer statusline
  au FocusGained,VimEnter,WinEnter,BufWinEnter *
    \ setlocal statusline=%!StatusLineRenderer()
  " show blurred buffer statusline
  au FocusLost,VimLeave,WinLeave,BufWinLeave *
    \ setlocal statusline&
  " restore statusline highlights on colorscheme update
  au Colorscheme * call <SID>StatusLineHighlights()
augroup END
" }}}
