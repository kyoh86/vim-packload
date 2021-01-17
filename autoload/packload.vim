" packload.vim - 
" Maintainer:   kyoh86
" License:		MIT License(http://www.opensource.org/licenses/MIT)

if exists('g:autoloaded_packload')
  finish
endif
let g:autoloaded_packload = 1

let s:save_cpo = &cpo
set cpo&vim

function! packload#load(bang, ...) abort
  if len(a:000) < 2
    return
  endif
  let l:packages = a:000[1:]

  " glob package paths
  if len(l:packages) == 0
    echohl WarningMsg | echoerr 'Empty <packages>' | echohl None
    return
  endif
  if len(l:packages) == 1
    let l:pkg_pat = l:packages[0]
  else
    let l:pkg_pat = '{' . join(l:packages, ',') . '}'
  endif

  " glob pack paths
  let l:pth_pat = '{' . &packpath . '}'
  if match(l:pth_pat, ',') < 0
    let l:pth_pat = &patckpath
  endif

  let l:pattern = join([l:pth_pat, 'pack', l:pkg_pat, 'opt', '*'], '/')

  let l:coverage = packload#coverage#new(l:packages)
  for l:plugin_path in glob(l:pattern, v:false, v:true)
    let l:dir = fnamemodify(l:plugin_path, ':h')
    let l:plugin = fnamemodify(l:dir, ':t')
    let l:dir = fnamemodify(l:dir, ':h')
    let l:dir = fnamemodify(l:dir, ':h')
    let l:package = fnamemodify(l:dir, ':t')
    call l:coverage.mark(l:package)
    call execute('packadd' . a:bang . ' ' . l:plugin, '')
  endfor

  let l:uncovered = l:coverage.uncovered()
  if len(l:uncovered) == 0
    return
  endif

  let l:msg = 'There is no plugin in ' . packload#echoutil#enum(l:uncovered)
  echohl WarningMsg | echo l:msg | echohl None
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
