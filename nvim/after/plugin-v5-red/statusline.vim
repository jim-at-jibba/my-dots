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
        \ . '  %{LspStatus()} '
endfun

fun! StatusLineFilename()
  if (&ft ==? 'netrw') | return '*' | endif
  return substitute(expand('%'), '^' . getcwd() . '/\?', '', 'i')
endfun

function! LspStatus() abort
  " https://dev.to/casonadams/neovim-and-its-built-in-language-server-protocol-3j8g
  "if luaeval('#vim.lsp.buf_get_clients() > 0')
  "  return luaeval("require('lsp-status').status()")
  "endif

  "return ''
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors

  return l:counts.total == 0 ? 'OK' : printf(
        \   '%dW %dE ',
        \   all_non_errors,
        \   all_errors
        \)
endfunction

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
  let &statusline = ' %{StatusLineFilename()}%=  %{LspStatus()} '
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
