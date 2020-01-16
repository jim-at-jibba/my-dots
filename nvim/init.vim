"     / __ )___  _____/ /___  _| |  / /  _/  |/  / __ \/ ____/
"    / __  / _ \/ ___/ __/ / / / | / // // /|_/ / /_/ / /
"   / /_/ /  __(__  ) /_/ /_/ /| |/ // // /  / / _, _/ /___
"  /_____/\___/____/\__/\__, / |___/___/_/  /_/_/ |_|\____/
"                      /____/
" Setup plug  ---------------------------------------------------------------{{{

call plug#begin('~/.local/share/nvim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" CSS
Plug 'hail2u/vim-css3-syntax'
Plug 'ap/vim-css-color'

" Look and feel
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'arcticicestudio/nord-vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'romainl/flattened'
Plug 'mhartington/oceanic-next'

" git
Plug 'jreybert/vimagit'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

"nerdtree
Plug 'scrooloose/nerdtree'
Plug 'xuyuanp/nerdtree-git-plugin'

" Utilities
Plug 'honza/vim-snippets'
Plug 'easymotion/vim-easymotion'
Plug 'Raimondi/delimitMate'
Plug 'scrooloose/nerdcommenter'
Plug 'vimwiki/vimwiki'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

" Javascript
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mxw/vim-jsx'
Plug 'heavenshell/vim-jsdoc'

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

  nnoremap ; :
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

  " NERDCommenter
  vmap ++ <plug>NERDCommenterToggle
  nmap ++ <plug>NERDCommenterToggle

  nmap <silent> <leader>/ :nohlsearch<CR>

  map <leader>w <Plug>(easymotion-bd-w)
  nmap s <Plug>(easymotion-s)
  nmap s <Plug>(easymotion-s2)

  " Search for word under cursor
  " nnoremap <silent> <Leader>f yiw :Rg <C-R>
  " xnoremap <leader>f :Rg <space> yiw <C-r> "

"}}}

" Commands ------------------------------------------------------------------{{{

command! -nargs=0 Todos         :CocList -A --normal grep -e TODO|FIXME
command! -nargs=0 Status        :CocList -A --normal gstatus

"}}}

" Themes, Commands, etc  ----------------------------------------------------{{{
  if (has("termguicolors"))
    set termguicolors
  endif
  syntax on
  set t_Co=256
  set background=dark
  "colorscheme flattened_dark
  "colorscheme nord
  "let g:nord_italic_comments=1

  let g:oceanic_next_terminal_bold = 1
  let g:oceanic_next_terminal_italic = 1
  colorscheme OceanicNext
"}}}

" Fold, gets it's own section  ----------------------------------------------{{{

  function! MyFoldText() " {{{
      let line = getline(v:foldstart)
      let nucolwidth = &fdc + &number * &numberwidth
      let windowwidth = winwidth(0) - nucolwidth - 3
      let foldedlinecount = v:foldend - v:foldstart

      " expand tabs into spaces
      let onetab = strpart('          ', 0, &tabstop)
      let line = substitute(line, '\t', onetab, 'g')

      let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
      " let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - len('lines')
      " let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - len('lines   ')
      let fillcharcount = windowwidth - len(line)
      " return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . ' Lines'
      return line . '…' . repeat(" ",fillcharcount)
  endfunction " }}}

  set foldtext=MyFoldText()

  autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
  autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

  autocmd FileType vim setlocal fdc=1
  set foldlevel=99

  " Space to toggle folds.
  nnoremap <leader> za
  vnoremap <leader> za
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType vim setlocal foldlevel=0

  autocmd FileType javascript,html,css,scss,typescript setlocal foldlevel=99

  autocmd FileType css,scss,json setlocal foldmethod=marker
  autocmd FileType css,scss,json setlocal foldmarker={,}

  let g:xml_syntax_folding = 1
  autocmd FileType xml setl foldmethod=syntax

  autocmd FileType html setl foldmethod=expr
  autocmd FileType html setl foldexpr=HTMLFolds()

  autocmd FileType javascript,typescript,json setl foldmethod=syntax

" }}}

" vim-airline ---------------------------------------------------------------{{{

  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#coc#enabled = 1
  let airline#extensions#coc#error_symbol = '💩:'
  let airline#extensions#coc#warning_symbol = '❗️:'
  let g:airline#extensions#mike#enabled = 0
  set hidden
  let g:airline#extensions#tabline#fnamemod = ':t'
  let g:airline#extensions#tabline#buffer_idx_mode = 1
  let g:airline#extensions#wordcount#enabled = 0
  let g:airline_powerline_fonts = 1
  let g:airline_symbols.branch = ''
  "let g:airline_theme='solarized'
  let g:airline_theme='oceanicnext'
  "let g:airline_theme='nord'
  nmap <leader>, :bnext<CR>
  tmap <leader>, <C-\><C-n>:bnext<cr>
  nmap <leader>. :bprevious<CR>
  tmap <leader>. <C-\><C-n>:bprevious<CR>
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
  nmap <leader>9 <Plug>AirlineSelectTab9
"}}}

" NERDTree ---------------------------------------------------------------{{{

  map <leader><leader>1 :NERDTreeToggle<CR>
  let NERDTreeShowHidden=1
  let NERDTreeHijackNetrw=0
  let g:WebDevIconsUnicodeDecorateFolderNodes = 1
  let g:NERDTreeWinSize=45
  let g:NERDTreeAutoDeleteBuffer=1
  let g:WebDevIconsOS = 'Darwin'
  let NERDTreeMinimalUI=1
  let NERDTreeCascadeSingleChildDir=1
  let g:NERDTreeHeader = 'hello'

  if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
  endif
" }}}

" Vim-Devicons -------------------------------------------------------------0{{{

  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed
  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['js'] = ''
  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['vim'] = ''
  let g:webdevicons_enable_airline_tabline = 1
  let g:webdevicons_enable_airline_statusline = 1

" }}}

" Coc -------------------------------------------------------------0{{{

  let g:coc_global_extensions = [
    \ 'coc-snippets',
    \ 'coc-pairs',
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
    \ 'coc-python'
    \ ]
  " always show signcolumns
  set signcolumn=yes

  " Use tab for trigger completion with characters ahead and navigate.
  " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
  "inoremap <silent><expr> <TAB>
  "      \ pumvisible() ? "\<C-n>" :
  "      \ <SID>check_back_space() ? "\<TAB>" :
  "      \ coc#refresh()
  "inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  "function! s:check_back_space() abort
  "  let col = col('.') - 1
  "  return !col || getline('.')[col - 1]  =~# '\s'
  "endfunction

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

  nmap <silent> <leader>dd <Plug>(coc-definition)
  nmap <silent> <leader>dy <Plug>(coc-type-definition)
  nmap <silent> <leader>dr <Plug>(coc-references)
  nmap <silent> <leader>dj <Plug>(coc-implementation)
  nnoremap <silent> <leader>gh :call <SID>show_documentation()<CR>


  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')

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

" }}}

" FZF --------------------------------------------------------------------{{{

  " Extended Rg function using FZF
  command! -bang -nargs=* Rg
   \ call fzf#vim#grep(
   \   'rg --column --line-number --ignore-case --no-heading --color=always '.shellescape(<q-args>), 3,
   \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
   \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '§'),
   \   <bang>0)

  let g:fzf_commits_log_options = '--graph --color=always
    \ --format="%C(yellow)%h%C(red)%d%C(reset)
    \ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'

  " !&diff unhighlights changed code - https://vi.stackexchange.com/questions/625/how-do-i-use-vim-as-a-diff-tool
  if !&diff
    nnoremap <silent> <C-p> :Files<Cr>
    nnoremap <leader>a :Rg<Cr>
    nnoremap <silent> <leader>e :call Fzf_dev()<CR>
    nnoremap <silent> <Leader>g :GFiles?<CR>
    nnoremap <silent> <Leader>c  :Commits<CR>
    nnoremap <silent> <Leader>bc :BCommits<CR>
  endif

  " View files with preview
  function! Fzf_dev()
  let l:fzf_files_options = '--preview "bat --theme="zenburn" --style=numbers,changes --color always {2..-1} | head -'.&lines.'"'

  function! s:files()
    let l:files = split(system($FZF_DEFAULT_COMMAND), '\n')
    return s:prepend_icon(l:files)
  endfunction

  function! s:prepend_icon(candidates)
    let l:result = []
    for l:candidate in a:candidates
      let l:filename = fnamemodify(l:candidate, ':p:t')
      let l:icon = WebDevIconsGetFileTypeSymbol(l:filename, isdirectory(l:filename))
      call add(l:result, printf('%s %s', l:icon, l:candidate))
    endfor

    return l:result
  endfunction

  function! s:edit_file(item)
    let l:pos = stridx(a:item, ' ')
    let l:file_path = a:item[pos+1:-1]
    execute 'silent e' l:file_path
  endfunction

  call fzf#run({
        \ 'source': <sid>files(),
        \ 'sink':   function('s:edit_file'),
        \ 'options': '-m ' . l:fzf_files_options,
        \ 'down':    '40%' })
  endfunction

  " OPen FZF with all open buffers
  function! s:buflist()
    redir => ls
    silent ls
    redir END
    return split(ls, '\n')
  endfunction

  function! s:bufopen(e)
    execute 'buffer' matchstr(a:e, '^[ 0-9]*')
  endfunction

  nnoremap <silent> <Leader><Enter> :call fzf#run({
  \   'source':  reverse(<sid>buflist()),
  \   'sink':    function('<sid>bufopen'),
  \   'options': '+m',
  \   'down':    len(<sid>buflist()) + 2
  \ })<CR>

"}}}

" Random --------------------------------------------------------------------{{{

" Trim whitespace on save
let blacklist = ['md', 'markdown', 'mdown']
 :autocmd BufWritePost * if index(blacklist, &ft) < 0 | :StripWhitespace

let g:NERDCreateDefaultMappings = 0


"}}}

" Close Tag --------------------------------------------------------------------{{{
  let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.erb,*.jsx,*.tsx"
"}}}

" VimWiki -----------------------------------------------------------------{{{
" Run multiple wikis "
let g:vimwiki_list = [
                      \{'path': '~/Google Drive/VimWiki/tech.wiki', 'syntax': 'markdown', 'ext': '.mkd'},
                \]
let g:vimwiki_global_ext=0
"}}}

" Functions -----------------------------------------------------------------{{{

function! s:show_documentation()
  if coc#util#has_float()
    call coc#util#float_hide()
  elseif (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
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
