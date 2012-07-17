" File Description {{{
" =============================================================================
" Ftplugin for CCTree for C and CPP files 
"                                                  by Ben Wu
"                                                     benwu@fnal.gov
" Usage :
"
"
" =============================================================================
" }}}

fun! s:CCTree() "{{{
  let a:CctreeVim = expand('~') . "/.vim/bundle/CCTree/cctree.vim"
  if !filereadable(a:CctreeVim)
    return ""
  endif

  if !exists('g:CscopePath') 
    return ""
  endif

  let a:CscopeFile = g:CscopePath . '/cscope.out'
  if !filereadable(a:CscopeFile)
    return ""
  endif

  let g:CCTreeKeyDepthPlus = '='
  let g:CCTreeKeyDepthMinus = '-'
  let g:CCTreeKeySourceDepthPlus = '<C-\>='
  let g:CCTreeKeySourceDepthMinus = '<C-\>-'

  execute 'source' . a:CctreeVim
  let g:CCTreeUseUTF8Symbols = 1 
  ""Perl interface is typically faster than native Vimscript.
  "let g:CCTreeUsePerl = 1 

  let a:CctreeFile = g:CscopePath . '/cctree.out'
  let a:CcglueFile = g:CscopePath . '/ccglue.out'
  let a:XrefFile = g:CscopePath . '/xref.out'
  if filereadable(a:CcglueFile)
    silent execute 'CCTreeLoadXRefDB' . a:CcglueFile
  elseif filereadable(a:XrefFile)
    silent execute 'CCTreeLoadXRefDB' . a:XrefFile
  elseif filereadable(a:CctreeFile)
    silent execute 'CCTreeLoadXRefDB' . a:CctreeFile
  else
    let choice = confirm("Do want you to load from cscope File?", "&Yes\n&No")
    if choice == 1
       execute 'CCTreeLoadDB' . a:CscopeFile
    endif
  endif

  "" Map locally again

  exec 'nnoremap <buffer> <silent> '.g:CCTreeKeyTraceReverseTree.' :CCTreeTraceReverse <C-R>=
        \expand("<cword>")<CR><CR>:wincmd p<CR>'
  exec 'nnoremap <buffer> <silent> '.g:CCTreeKeyTraceForwardTree.' :CCTreeTraceForward <C-R>=
        \expand("<cword>")<CR><CR>:wincmd p<CR>'

  exec 'nnoremap <silent> '.g:CCTreeKeySaveWindow. ' :CCTreeWindowSaveCopy<CR>'
  exec 'nnoremap <silent> '.g:CCTreeKeyToggleWindow. ' :CCTreeWindowToggle<CR>'

  exec 'nnoremap <buffer> <silent> '.g:CCTreeKeySourceDepthPlus.
        \ ' :CCTreeRecurseDepthPlus<CR>:wincmd p<CR>'
  exec 'nnoremap <buffer> <silent> '.g:CCTreeKeySourceDepthMinus.
        \ ' :CCTreeRecurseDepthMinus<CR>:wincmd p<CR>'

endfunction "}}}

command! -nargs=0 CCTree               call s:CCTree()
