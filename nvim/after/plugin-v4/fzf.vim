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
