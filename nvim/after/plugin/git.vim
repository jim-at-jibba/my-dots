" Fugitive
" nmap <leader>gh :diffget //3<CR>
" nmap <leader>gu :diffget //2<CR>
nmap <leader>gs :G<CR>

" Signify
nmap <silent> <cr> <Plug>(signify-next-hunk)
nmap <silent> <backspace> <Plug>(signify-prev-hunk)
nmap <leader>gd :SignifyDiff<CR>

nmap <leader>gb :BlamerToggle<CR>

" Vimagit
" let g:magit_default_fold_level = 0
