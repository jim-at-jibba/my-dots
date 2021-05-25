" Fugitive
" nmap <leader>gh :diffget //3<CR>
" nmap <leader>gu :diffget //2<CR>
nmap <leader>gs :G<CR>
nnoremap <leader>gd :Gdiff master<cr>
nnoremap <leader>gl :G log -100<cr>

" Signify
nmap <silent> <cr> <Plug>(signify-next-hunk)
nmap <silent> <backspace> <Plug>(signify-prev-hunk)
nmap <leader>gd :SignifyDiff<CR>

nmap <leader>gb :BlamerToggle<CR>

" Vimagit
" let g:magit_default_fold_level = 0
