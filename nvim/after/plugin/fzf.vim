let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8}}
inoremap <expr> <c-x><c-f> fzf#vim#complete("fd <Bar> xargs realpath --relative-to " . expand("%:h"))

if has('nvim')
  au! TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
  au! FileType fzf tunmap <buffer> <Esc>
endif

if !&diff
  nnoremap <silent> <C-p> :Files<Cr>
  nnoremap <silent> <Leader>g :GFiles?<CR>
"  nnoremap <silent> <Leader>c  :Commits<CR>
  nnoremap <silent> <Leader>bc :BCommits<CR>
endif
