let g:telescope_cache_results = 1
let g:telescope_prime_fuzzy_find  = 1

nnoremap <leader>pw :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
nnoremap <leader>b :lua require('telescope.builtin').buffers({show_all_buffers = true})<CR>
" nnoremap <leader>f :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For >")})<CR>
nnoremap <leader>f :lua require('telescope.builtin').live_grep()<CR>
nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>
nnoremap <Leader>pf :lua require('telescope.builtin').find_files()<CR>
nnoremap <Leader>dr :lua require('telescope.builtin').lsp_references()<CR>
nnoremap <Leader>ol :lua require('telescope.builtin').loclist()<CR>
nnoremap <Leader>c :lua require('telescope.builtin').git_commits()<CR>
nnoremap <Leader>bc :lua require('telescope.builtin').git_bcommits()<CR>
nnoremap <Leader>g :lua require('telescope.builtin').git_status()<CR>
nnoremap <Leader>cR :lua require('telescope.builtin').reloader()<CR>

nnoremap <Leader>ca :lua require('telescope.builtin').lsp_code_actions()<CR>

lua << EOF
require('telescope').setup{
  defaults = {
    -- TEMP FIX: https://github.com/nvim-telescope/telescope.nvim/issues/484
    set_env = { ['COLORTERM'] = 'truecolor' },
    prompt_prefix = "🦄 ",
  }
}

EOF
