vim.cmd [[augroup Autogroup]]
vim.cmd [[autocmd BufWrite,BufEnter,InsertLeave * lua vim.lsp.diagnostic.set_loclist({open_loclist = false})]]
vim.cmd [[augroup END]]
