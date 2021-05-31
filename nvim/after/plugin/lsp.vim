" nnoremap <leader>dn :lua vim.lsp.diagnostic.goto_next()<CR>
" nnoremap <leader>dp :lua vim.lsp.diagnostic.goto_prev()<CR>
" nnoremap <leader>dl :lua vim.lsp.diagnostic.set_loclist()<CR>
nnoremap <leader>df :lua require'lsp-ext'.peek_definition()<cr>

" trigger autocomplete in insert mode
"inoremap <c-space> <c-x><c-o>

let g:lexima_no_default_rules = v:true
call lexima#set_default_rules()
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm(lexima#expand('<LT>CR>', 'i'))
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

let g:UltiSnipsSnippetDirectories=["Ultisnips", "mysnippets"]
