function! neoformat#formatters#reason() abort
    return ['refmt']
endfunction

function! neoformat#formatters#reason#refmt() abort
    return {
        \ 'exe': 'refmt',
        \ 'stdin': 1,
        \ }
endfunction
