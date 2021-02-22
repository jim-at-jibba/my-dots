" Coc -------------------------------------------------------------0{{{

  let g:coc_global_extensions = [
    \ 'coc-snippets',
    \ 'coc-tsserver',
    \ 'coc-eslint',
    \ 'coc-prettier',
    \ 'coc-json',
    \ 'coc-emmet',
    \ 'coc-lists',
    \ 'coc-json',
    \ 'coc-html',
    \ 'coc-dictionary',
    \ 'coc-git',
    \ 'coc-python',
    \ 'coc-highlight',
    \ 'coc-styled-components',
    \ 'coc-css',
    \ 'coc-html',
    \ 'coc-markdownlint',
    \ 'coc-go'
    \ ]

  inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  let g:coc_snippet_next = '<tab>'

  " Use <c-space> to trigger completion.
  inoremap <silent><expr> <c-space> coc#refresh()

  " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
  " Coc only does snippet and additional edit on confirm.
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  " Or use `complete_info` if your vim support it, like:
  " inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

  " Use `[g` and `]g` to navigate diagnostics
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " navigate git hunks
  nmap <silent> <cr> <Plug>(coc-git-nextchunk)
  nmap <silent> <backspace> <Plug>(coc-git-prevchunk)
  nmap <silent> <leader>hi <Plug>(coc-git-chunkinfo)

  nmap <silent> <leader>dd <Plug>(coc-definition)
  nmap <silent> <leader>dy <Plug>(coc-type-definition)
  nmap <silent> <leader>dr <Plug>(coc-references)
  nmap <silent> <leader>dj <Plug>(coc-implementation)
  nnoremap <silent> <leader>gh :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
      call CocActionAsync('doHover')
    else
      execute '!' . &keywordprg . " " . expand('<cword>')
    endif
  endfunction

  " Highlight symbol under cursor on CursorHold
  "autocmd CursorHold * silent call CocActionAsync('highlight')

  nnoremap <silent> <leader>co  :<C-u>CocList outline<cr>
  nnoremap <silent> <leader>cs  :<C-u>CocList -I symbols<cr>

  " remap do action of current line
  nmap <leader>ac  <Plug>(coc-codeaction)

  " List errors
  nnoremap <silent> <leader>cl  :<C-u>CocList diagnostics<cr>

  " list commands available in tsserver (and others)
  nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>

  " restart when tsserver gets wonky
  nnoremap <silent> <leader>cR  :<C-u>CocRestart<CR>

  " Apply AutoFix to problem on the current line.
  nmap <leader>qf  <Plug>(coc-fix-current)

  " Symbol renaming.
  nmap <leader>rn <Plug>(coc-rename)

  " Remap for do codeAction of selected region
  function! s:cocActionsOpenFromSelected(type) abort
    execute 'CocCommand actions.open ' . a:type
  endfunction

  xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
  nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@

  autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

" }}}