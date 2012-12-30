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

let s:plugin_dir = expand("<sfile>:p:h:h")

fun! s:CCTree() "{{{
  let a:CctreeVim = s:plugin_dir . "/cctree.vim"
  if !filereadable(a:CctreeVim) 
    return ""
  endif

  if !exists('g:cscope_relative_path') 
    return ""
  endif

  let a:CscopeFile = g:cscope_relative_path . '/cscope.out'
  if !filereadable(a:CscopeFile)
    return ""
  endif

  let g:CCTreeKeyDepthPlus = '='
  let g:CCTreeKeyDepthMinus = '-'
  let g:CCTreeKeySourceDepthPlus = '<C-\>='
  let g:CCTreeKeySourceDepthMinus = '<C-\>-'

  if !exists("g:loaded_cctree") || g:loaded_cctree != 1
    execute 'source' . a:CctreeVim
  endif

  let g:CCTreeUseUTF8Symbols = 1 
  ""Perl interface is typically faster than native Vimscript.
  "let g:CCTreeUsePerl = 1 

  let a:CctreeFile = g:cscope_relative_path . '/cctree.out'
  let a:CcglueFile = g:cscope_relative_path . '/ccglue.out'
  let a:XrefFile   = g:cscope_relative_path . '/xref.out'
  if filereadable(a:CcglueFile)
    silent execute 'CCTreeLoadXRefDB ' . a:CcglueFile
  elseif filereadable(a:XrefFile)
    silent execute 'CCTreeLoadXRefDB ' . a:XrefFile
  elseif filereadable(a:CctreeFile)
    silent execute 'CCTreeLoadXRefDB ' . a:CctreeFile
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

fun! s:CCTreeUpdate() "{{{
  if !exists('g:cscope_relative_path') 
    return ""
  endif

  let a:CscopeFile = g:cscope_relative_path . '/cscope.out'
  if !filereadable(a:CscopeFile)
    return ""
  endif

  let a:CctreeVim = s:plugin_dir . "/cctree.vim"
  if !filereadable(a:CctreeVim) 
    return ""
  endif

  if !exists("g:loaded_cctree") || g:loaded_cctree != 1
    execute 'source' . a:CctreeVim)
  endif

  let a:CctreeFile = g:cscope_relative_path . '/cctree.out'
  let a:CcglueFile = g:cscope_relative_path . '/ccglue.out'
  let a:XrefFile   = g:cscope_relative_path . '/xref.out'
  let a:FoundFile  = ''
  if filereadable(a:CcglueFile)
    silent execute 'silent! !rm ' . a:CcglueFile
    let a:FoundFile  = a:CcglueFile
  elseif filereadable(a:XrefFile)
    silent execute 'silent! !rm ' . a:XrefFile
    let a:FoundFile  = a:XrefFile
  elseif filereadable(a:CctreeFile)
    silent execute 'silent! !rm ' . a:CctreeFile
    let a:FoundFile  = a:CctreeFile
  endif

  execute 'CCTreeLoadDB ' . a:CscopeFile
  execute 'CCTreeSaveXRefDB ' . a:FoundFile
endfunction "}}}

command! -nargs=0 CCTree               call s:CCTree()
command! -nargs=0 CCTreeUpdate         call s:CCTreeUpdate()
