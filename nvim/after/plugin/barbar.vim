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

let bufferline = get(g:, 'bufferline', {})
let bufferline.animation = v:true
let bufferline.icons = "both"
let bufferline.numbers = v:true
let bufferline.closable = v:false
let bufferline.clickable = v:false
let bufferline.semantic_letters = v:true
let bufferline.letters =
  \ 'asdfjkl;ghnmxcbziowerutyqpASDFJKLGHNMXCBZIOWERUTYQP'
let bufferline.maximum_padding = 4
