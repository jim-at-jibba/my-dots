nmap <silent> <leader> [g <Plug>(ale_previous_wrap)
nmap <silent> <leader>]g <Plug>(ale_next_wrap)

let g:ale_linters = {
\   'javascript': ['eslint'],
\   'javascriptreact': ['eslint'],
\   'typescript': ['eslint', 'tslint'],
\   'typescriptreact': ['eslint', 'tslint'],
\   'go': ['golint'],
\   'html': ['htmlhint'],
\}

let g:ale_fixers = {
\   'javascript': ['prettier', 'eslint'],
\   'javascriptreact': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\   'typescriptreact': ['prettier', 'eslint'],
\   'go': ['gofmt'],
\   'css': ['prettier'],
\   'html': ['prettier'],
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\}
let g:ale_linters_explicit = 1
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1
let g:ale_sign_error = '💩'
let g:ale_sign_warning = '📣 '
let g:ale_disable_lsp = 1
let g:ale_open_list = 0
let g:ale_virtualtext_cursor = 1
