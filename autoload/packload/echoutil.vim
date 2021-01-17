" echoutil.vim - 
" Maintainer:   kyoh86
" License:		MIT License(http://www.opensource.org/licenses/MIT)

if exists('g:autoloaded_packload_echoutil')
  finish
endif
let g:autoloaded_packload_echoutil = 1

let s:save_cpo = &cpo
set cpo&vim

function! packload#echoutil#enum(items, op = 'and') abort
  let l:op = ' ' . a:op . ' '
  if len(a:items) == 0
    return ''
  endif
  if len(a:items) == 1
    return a:items[0]
  endif
  if len(a:items) == 2
    return join(a:items, l:op)
  endif
  " if len(a:items) >= 3
   return join(a:items[:-2], ', ') . l:op . a:items[-1]
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
