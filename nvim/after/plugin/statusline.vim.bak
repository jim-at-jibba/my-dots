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
