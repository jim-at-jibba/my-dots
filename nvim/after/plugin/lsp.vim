nnoremap <leader>dn :lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <leader>dp :lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <leader>dl :lua vim.lsp.diagnostic.set_loclist()<CR>
nnoremap <leader>df :lua require'lsp-ext'.peek_definition()<cr>

" trigger autocomplete in insert mode
inoremap <c-space> <c-x><c-o>


let g:UltiSnipsSnippetDirectories=["Ultisnips", "mysnippets"]
