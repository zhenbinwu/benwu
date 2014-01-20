" OmniCppComplete initialization
call omni#cpp#complete#Init()

"" Setup CMS Tag file
fun! s:SetCMSTag() "{{{
  let curdir = getcwd()
  "" Setup for CMSSW
  if  !exists("$CMSSW_BASE") || match(curdir, expand("$CMSSW_BASE")) == -1 
    return 0
  endif
  set tags+=CMSTag

  while !filereadable("CMSTag") && matchend(getcwd(), expand("$CMSSW_BASE")) != len(getcwd())
    cd ..
  endwhile
  let g:test = getcwd()

  if filereadable("CMSTag")
    set tags+=CMSTag
  endif

  execute "cd " . curdir
  return 1
endfunction "}}}
call s:SetCMSTag()


fun! s:PreviewSyn() "{{{
  if ! &pvw 
    return 0
  endif

  syn match CppFunc /cmd:.*$/hs=s+4
  syn match CppSig /signature:.*$/hs=s+10
  hi link CppFunc Keyword
  hi link CppSig Define
endfunction "}}}
autocmd BufWinEnter * call s:PreviewSyn()
