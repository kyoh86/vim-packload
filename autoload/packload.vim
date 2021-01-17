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
  for l:path in s:glob_package_opt(&packpath, a:packages)
    let l:plugin = fnamemodify(trim(l:path, '/\\'), ':t')
    packadd l:plugin
  endfor
endfunction

function! s:glob_package_opt(packpath, packages) abort
  if match(a:packages, ',') >= 0
    let l:packages = '{' . a:packages . '}'
  else
    let l:packages = a:packages
  endif
  let l:pattern = '{' . a:packpath . '}/pack/' . l:packages . '/opt/*'
  return glob(l:pattern, v:false, v:true)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
