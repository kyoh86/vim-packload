" coverage.vim - 
" Maintainer:   kyoh86
" License:		MIT License(http://www.opensource.org/licenses/MIT)

if exists('g:autoloaded_packload_coverage')
  finish
endif
let g:autoloaded_packload_coverage = 1

let s:save_cpo = &cpo
set cpo&vim

function! s:mark(key) abort dict
  let self.map[a:key] = v:false
endfunction

function! s:unmark(key) abort dict
  let self.map[a:key] = v:true
endfunction

function! s:should(key) abort dict
  return has_key(self.map, a:key)
endfunction

function! s:uncovered() abort dict
  let l:rest = []
  for [l:key, l:value] in items(self.map)
    if l:value == v:true
      call add(l:rest, l:key)
    endif
  endfor
  return l:rest
endfunction

function! packload#coverage#new(keys) abort
  let l:instance = {
        \ 'map': {},
        \ 'mark': function('<SID>mark'),
        \ 'unmark': function('<SID>unmark'),
        \ 'should': function('<SID>should'),
        \ 'uncovered': function('<SID>uncovered'),
        \ }
  for l:k in a:keys
    call l:instance.unmark(l:k)
  endfor
  return l:instance
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
