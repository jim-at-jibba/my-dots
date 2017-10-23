function! neoformat#formatters#json#enabled() abort
    return ['jsbeautify', 'prettydiff', 'jq', 'prettier']
endfunction

function! neoformat#formatters#json#jsbeautify() abort
    return neoformat#formatters#javascript#jsbeautify()
endfunction

function! neoformat#formatters#json#prettydiff() abort
    return neoformat#formatters#javascript#prettydiff()
endfunction

function! neoformat#formatters#json#jq() abort
    return {
            \ 'exe': 'jq',
            \ 'args': ['.'],
            \ }
endfunction

function! neoformat#formatters#json#prettier() abort
    return {
        \ 'exe': 'prettier',
        \ 'args': ['--stdin', '--parser', 'json'],
        \ 'stdin': 1,
        \ }
endfunction
