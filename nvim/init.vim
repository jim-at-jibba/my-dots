"     / __ )___  _____/ /___  _| |  / /  _/  |/  / __ \/ ____/
"    / __  / _ \/ ___/ __/ / / / | / // // /|_/ / /_/ / /
"   / /_/ /  __(__  ) /_/ /_/ /| |/ // // /  / / _, _/ /___
"  /_____/\___/____/\__/\__, / |___/___/_/  /_/_/ |_|\____/
"                      /____/
" Setup plug  ---------------------------------------------------------------{{{

call plug#begin('~/.local/share/nvim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf'
Plug 'shougo/denite.nvim'

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
Plug 'airblade/vim-gitgutter'
Plug 'jreybert/vimagit'

"nerdtree
Plug 'scrooloose/nerdtree'
Plug 'xuyuanp/nerdtree-git-plugin'

" Utilities
Plug 'Valloric/MatchTagAlways'
" Plug 'alvan/vim-closetag'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'easymotion/vim-easymotion'
Plug 'Raimondi/delimitMate'
Plug 'scrooloose/nerdcommenter'

" Javascript
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mxw/vim-jsx'
Plug 'heavenshell/vim-jsdoc'

call plug#end()

" }}}


" System Settings  ----------------------------------------------------------{{{
  "set termguicolors
  set nopaste
  set  number
  set tabstop=2 shiftwidth=2 expandtab
  let mapleader = ' '
  set spell
  set relativenumber
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

  set splitbelow
  set splitright

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

  " === Denite shorcuts === "
  "   <leader>t - Browse list of files in current directory
  "   <leader>g - Search current directory for occurences of given term and close window if no results
  "   <leader>j - Search current directory for occurences of word under cursor
  " nmap ; :Denite buffer<CR>

  "nnoremap <silent> <c-p> :Denite file/rec<CR>
  nmap <leader>t :DeniteProjectDir file/rec<CR>
  nnoremap <leader>g :<C-u>Denite grep:. -no-empty<CR>
  nnoremap <leader>j :<C-u>DeniteCursorWord grep:.<CR>

  autocmd FileType denite-filter call s:denite_filter_my_settings()
  function! s:denite_filter_my_settings() abort
    imap <silent><buffer> <C-o>
    \ <Plug>(denite_filter_quit)
    inoremap <silent><buffer><expr> <Esc>
    \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> <Esc>
    \ denite#do_map('quit')
    inoremap <silent><buffer><expr> <CR>
    \ denite#do_map('do_action')
  endfunction

  autocmd FileType denite call s:denite_my_settings()
  function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR>
    \ denite#do_map('do_action')
    nnoremap <silent><buffer><expr> q
    \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> <Esc>
    \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> d
    \ denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p
    \ denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> i
    \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <C-o>
    \ denite#do_map('open_filter_buffer')
  endfunction

  " === coc.nvim === "
  nmap <silent> <leader>dd <Plug>(coc-definition)
  nmap <silent> <leader>dy <Plug>(coc-type-definition)
  nmap <silent> <leader>dr <Plug>(coc-references)
  nmap <silent> <leader>dj <Plug>(coc-implementation)
  nnoremap <silent> <leader>gh :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if &filetype == 'vim'
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')

  nnoremap <silent> <leader>co  :<C-u>CocList outline<cr>
  nnoremap <silent> <leader>cs  :<C-u>CocList -I symbols<cr>

  " List errors
  nnoremap <silent> <leader>cl  :<C-u>CocList diagnostics<cr>

  " list commands available in tsserver (and others)
  nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>

  " restart when tsserver gets wonky
  nnoremap <silent> <leader>cR  :<C-u>CocRestart<CR>


  nmap <silent> <leader>/ :nohlsearch<CR>

  map <leader>w <Plug>(easymotion-bd-w)
  nmap s <Plug>(easymotion-s)
  nmap s <Plug>(easymotion-s2)

"}}}

" Themes, Commands, etc  ----------------------------------------------------{{{
  if (has("termguicolors"))
    set termguicolors
  endif
  syntax on
  set t_Co=256
  set background=dark
  " colorscheme flattened_dark
  "colorscheme nord
  "let g:nord_italic_comments=1

  let g:oceanic_next_terminal_bold = 1
  let g:oceanic_next_terminal_italic = 1
  colorscheme OceanicNext

  set scrolloff=5
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
  nnoremap <Space> za
  vnoremap <Space> za
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

" Denite --------------------------------------------------------------------{{{
  try
  " === Denite setup ==="
  " Use ripgrep for searching current directory for files
  " By default, ripgrep will respect rules in .gitignore
  "   --files: Print each file that would be searched (but don't search)
  "   --glob:  Include or exclues files for searching that match the given glob
  "            (aka ignore .git files)
  "
  call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])

  " Use ripgrep in place of "grep"
  call denite#custom#var('grep', 'command', ['rg'])

  " Custom options for ripgrep
  "   --vimgrep:  Show results with every match on it's own line
  "   --hidden:   Search hidden directories and files
  "   --heading:  Show the file name above clusters of matches from each file
  "   --S:        Search case insensitively if the pattern is all lowercase
  call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

  " Recommended defaults for ripgrep via Denite docs
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])

  " Remove date from buffer list
  call denite#custom#var('buffer', 'date_format', '')

  " Open file commands
  call denite#custom#map('insert,normal', "<C-t>", '<denite:do_action:tabopen>')
  call denite#custom#map('insert,normal', "<C-v>", '<denite:do_action:vsplit>')
  call denite#custom#map('insert,normal', "<C-h>", '<denite:do_action:split>')

  " Custom options for Denite
  "   auto_resize             - Auto resize the Denite window height automatically.
  "   prompt                  - Customize denite prompt
  "   direction               - Specify Denite window direction as directly below current pane
  "   winminheight            - Specify min height for Denite window
  "   highlight_mode_insert   - Specify h1-CursorLine in insert mode
  "   prompt_highlight        - Specify color of prompt
  "   highlight_matched_char  - Matched characters highlight
  "   highlight_matched_range - matched range highlight
  let s:denite_options = {'default' : {
  \ 'split': 'floating',
  \ 'start_filter': 1,
  \ 'auto_resize': 1,
  \ 'source_names': 'short',
  \ 'prompt': 'λ:',
  \ 'statusline': 0,
  \ 'highlight_matched_char': 'WildMenu',
  \ 'highlight_matched_range': 'Visual',
  \ 'highlight_window_background': 'Visual',
  \ 'highlight_filter_background': 'StatusLine',
  \ 'highlight_prompt': 'StatusLine',
  \ 'winrow': 1,
  \ 'vertical_preview': 1
  \ }}

  " Loop through denite options and enable them
  function! s:profile(opts) abort
    for l:fname in keys(a:opts)
      for l:dopt in keys(a:opts[l:fname])
        call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
      endfor
    endfor
  endfunction

  call s:profile(s:denite_options)
  catch
    echo 'Denite not installed. It should work after running :PlugInstall'
  endtry


"}}}

" vim-airline ---------------------------------------------------------------{{{

  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#mike#enabled = 0
  set hidden
  let g:airline#extensions#tabline#fnamemod = ':t'
  let g:airline#extensions#tabline#buffer_idx_mode = 1
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#neomake#error_symbol='• '
  let g:airline#extensions#neomake#warning_symbol='•  '
  let g:airline_symbols.branch = ''
  " let g:airline_theme='solarized'
  let g:airline_theme='oceanicnext'
  " let g:airline_theme='nord'
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
    \ ]
  " always show signcolumns
  set signcolumn=yes

  " Use tab for trigger completion with characters ahead and navigate.
  " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

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

" }}}

" Random --------------------------------------------------------------------{{{

" Trim whitespace on save
let blacklist = ['md', 'markdown', 'mdown']
 :autocmd BufWritePost * if index(blacklist, &ft) < 0 | :StripWhitespace

let g:NERDCreateDefaultMappings = 0


"}}}

" NeoSnippet --------------------------------------------------------------------{{{
" Map <C-k> as shortcut to activate snippet if available
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

" Load custom snippets from snippets folder
let g:neosnippet#snippets_directory='~/dotfiles/nvim/snippets'

" Hide conceal markers
let g:neosnippet#enable_conceal_markers = 0

" }}}

" Close Tag --------------------------------------------------------------------{{{
  let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.erb,*.jsx,*.tsx"
"}}}

