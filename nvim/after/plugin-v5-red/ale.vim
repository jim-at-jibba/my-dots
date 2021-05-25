nmap <silent> <leader> [d <Plug>(ale_previous_wrap)
nmap <silent> <leader>]d <Plug>(ale_next_wrap)

let g:ale_linters = {
\   'javascript': ['eslint'],
\   'javascriptreact': ['eslint'],
\   'typescript': ['eslint', 'tslint'],
\   'typescriptreact': ['eslint', 'tslint'],
\   'go': ['golint'],
\   'html': ['htmlhint'],
\   'yaml': ['yamllint'],
\   'json': ['jsonlint'],
\   'python': ['pylint']
\}

let g:ale_fixers = {
\   'javascript': ['prettier', 'eslint'],
\   'javascriptreact': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\   'typescriptreact': ['prettier', 'eslint'],
\   'go': ['gofmt'],
\   'css': ['prettier'],
\   'html': ['prettier'],
\   'yaml': ['yamlfix'],
\   'json': ['prettier'],
\   'python': ['add_blank_lines_for_python_control_statements', 'autoimport', 'black'],
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
