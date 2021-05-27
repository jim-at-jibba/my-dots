# Vim remaps

```
inoremap jj <Esc>
map q <Nop>

noremap H ^
noremap L g_

noremap <leader>kc :%bd<bar>e#<bar>bd#<CR>
nnoremap <leader>c :lclose<bar>b#<bar>bd #<CR> " close buffer without closing window

" disable Arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Simplier mappings for switching
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-L> <C-W><C-L>

" Align blocks of text and keep them selected
vmap < <gv
vmap > >gv

nmap <silent> <leader>/ :nohlsearch<CR>

" Copy to system posteboard
vnoremap  <leader>y  "+y
nnoremap  <leader>y  "+y

nnoremap <leader>u :UndotreeToggle<CR>

" Move selected line
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap <leader>p "_dP

nnoremap <leader>+ :vertical resize +5<CR>
nnoremap <leader>- :vertical resize -5<CR>

" BABBAR
nnoremap <silent> <C-s> :BufferPick<CR>
nnoremap <silent>    <leader>1 :BufferGoto 1<CR>
nnoremap <silent>    <leader>2 :BufferGoto 2<CR>
nnoremap <silent>    <leader>3 :BufferGoto 3<CR>
nnoremap <silent>    <leader>4 :BufferGoto 4<CR>
nnoremap <silent>    <leader>5 :BufferGoto 5<CR>
nnoremap <silent>    <leader>6 :BufferGoto 6<CR>
nnoremap <silent>    <leader>7 :BufferGoto 7<CR>
nnoremap <silent>    <leader>8 :BufferGoto 8<CR>
nnoremap <silent>    <leader>9 :BufferLast<CR>
nnoremap <silent>    <leader>q :BufferClose<CR>

"EMMET
imap <S-tab> <plug>(emmet-expand-abbr)

" FZF

inoremap <expr> <c-x><c-f> fzf#vim#complete("fd <Bar> xargs realpath --relative-to " . expand("%:h"))

" GIT

nmap <leader>gs :G<CR>
nnoremap <leader>gd :Gdiff master<cr>
nnoremap <leader>gl :G log -100<cr>
nmap <silent> <cr> <Plug>(signify-next-hunk)
nmap <silent> <backspace> <Plug>(signify-prev-hunk)
nmap <leader>gd :SignifyDiff<CR>

nmap <leader>gb :BlamerToggle<CR>

" LSP

nnoremap <leader>dn :lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <leader>dp :lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <leader>dl :lua vim.lsp.diagnostic.set_loclist()<CR>
nnoremap <leader>df :lua require'lsp-ext'.peek_definition()<cr>
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm(lexima#expand('<LT>CR>', 'i'))
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

mapper('n', '<leader>dd', '<cmd>lua vim.lsp.buf.definition()<CR>')
mapper('n', '<leader>d', '<cmd>lua vim.lsp.buf.implementation()<CR>')
mapper('n', '<leader>vsh', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
mapper('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
mapper('n', '<leader>gh', '<cmd>lua vim.lsp.buf.hover()<CR>')
mapper('n', '<leader>dr', ":lua require('lists').change_active('Quickfix')<CR>:lua vim.lsp.buf.references()<CR>") 
-- mapper('n', '<leader>dr', '<cmd>lua vim.lsp.buf.references()<CR>')

" MAXIMISER

nnoremap <leader>m :MaximizerToggle!<CR>

" LIST NAVIGATION

nnoremap <C-k> :cnext<CR>zz
nnoremap <C-j> :cprev<CR>zz
nnoremap <leader>k :lnext<CR>zz
nnoremap <leader>j :lprev<CR>zz
nnoremap <C-q> :call ToggleQFList(1)<CR>
nnoremap <leader>q :call ToggleQFList(0)<CR>

" TELESCOPE

nnoremap <leader>pw :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
nnoremap <leader>b :lua require('telescope.builtin').buffers({show_all_buffers = true})<CR>
nnoremap <leader>f :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For >")})<CR>
nnoremap <leader>f :lua require('telescope.builtin').live_grep()<CR>
nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>
nnoremap <Leader>pf :lua require('telescope.builtin').find_files()<CR>
nnoremap <Leader>dr :lua require('telescope.builtin').lsp_references()<CR>
nnoremap <Leader>ol :lua require('telescope.builtin').loclist()<CR>
" nnoremap <Leader>c :lua require('telescope.builtin').git_commits()<CR>
nnoremap <Leader>bc :lua require('telescope.builtin').git_bcommits()<CR>
nnoremap <Leader>g :lua require('telescope.builtin').git_status()<CR>
nnoremap <Leader>cR :lua require('telescope.builtin').reloader()<CR>

nnoremap <Leader>ca :lua require('telescope.builtin').lsp_code_actions()<CR>

" VIMTEST

nnoremap <silent> tt :TestNearest<CR>
nnoremap <silent> tf :TestFile<CR>
nnoremap <silent> ts :TestSuite<CR>
nnoremap <silent> t_ :TestLast<CR>


```
