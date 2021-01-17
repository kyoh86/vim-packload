" packload.vim - 
" Maintainer:   kyoh86
" License:		MIT License(http://www.opensource.org/licenses/MIT)

if exists('g:autoloaded_packload')
  finish
endif
let g:autoloaded_packload = 1

let s:save_cpo = &cpo
set cpo&vim

function! packload#load(packages) abort
  for l:plugin in s:glob_package(&packpath, a:packages)
    packadd l:plugin
  endfor
endfunction

function! s:glob_package(packpath, packages) abort
  let l:pattern = '{' . a:packpath . '}/*/{' . a:packages . '}'
  return glob(l:pattern, v:false, v:true)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
