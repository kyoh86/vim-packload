" packload.vim - 
" Maintainer:   kyoh86
" License:		MIT License(http://www.opensource.org/licenses/MIT)

if exists('g:autoloaded_packload')
  finish
endif
let g:autoloaded_packload = 1

let s:save_cpo = &cpo
set cpo&vim

function! packload#load(bang, packages) abort
  let l:sentinel = s:build_sentinel(a:packages)
  for l:path in s:glob_package_opt(&packpath, a:packages)
    let l:info = s:path_to_info(l:path)
    call l:sentinel.mark(l:info['package'])
    echo 'Loading ' . l:info['plugin']
    execute('packadd' . a:bang . ' ' . l:info['plugin'])
  endfor

  call l:sentinel.validate()
endfunction

function! s:sentinel_mark(package) abort dict
  let self.flag_map[a:package] = v:false
endfunction

function! s:sentinel_validate() abort dict
  let l:invalid = []
  for [l:package, l:rest] in items(self.flag_map)
    if l:rest == v:true
      call add(l:invalid, l:package)
    endif
  endfor
  
  if len(l:invalid) == 0
    " noop
  else
    echohl WarningMsg | echo 'There is no plugin in ' . s:text_enum_items(l:invalid) | echohl None
  endif
endfunction

function! s:text_enum_items(items) abort
  if len(a:items) == 0
    return ''
  endif
  if len(a:items) == 1
    return a:items[0]
  endif
  if len(a:items) == 2
    return join(a:items, ' and ')
  endif
  " if len(a:items) >= 3
   return join(a:items[:-2], ', ') . ' and ' . a:items[-1]
endfunction

function! s:build_sentinel(packages) abort
  let l:m = {}
  for l:p in split(a:packages, ',')
    let l:m[trim(l:p)] = v:true
  endfor
  return {
        \ 'flag_map': l:m,
        \ 'mark': function('<SID>sentinel_mark'),
        \ 'validate': function('<SID>sentinel_validate'),
        \ }
endfunction

function! s:path_to_info(path) abort
  let l:path = fnamemodify(a:path, ':h')
  let l:plugin = fnamemodify(l:path, ':t')
  let l:dir = fnamemodify(l:path, ':h')
  " HACK: assert l:dir ==# 'opt'
  let l:dir = fnamemodify(l:dir, ':h')
  let l:package = fnamemodify(l:dir, ':t')
  return {
        \ 'path': l:path,
        \ 'package': l:package,
        \ 'plugin': l:plugin,
        \ }
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
