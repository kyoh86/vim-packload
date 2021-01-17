" packload.vim - 
" Maintainer:   kyoh86
" License:		MIT License(http://www.opensource.org/licenses/MIT)

if exists('g:loaded_packload')
  finish
endif
let g:loaded_packload = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=+ Packload call packload#load('<args>')

let &cpo = s:save_cpo
unlet s:save_cpo
