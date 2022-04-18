if exists('g:loaded_whid') | finish | endif " stops plugin loading twice

let s:save_cpo = &cpo " save user coptions
set cpo&vim " reset them to the defaults

hi def link WhidHeader      Number
hi def link WhidSubHeader   Identifier

" Command to run our plugin
command! Whid lua require'whid'.whid()

let &cpo = s:save_cpo " and restore after
unlet s:save_cpo

let g:loaded_whid = 1
