" OmniCppComplete initialization
call omni#cpp#complete#Init()

"" Setup CMS Tag file
fun! SetCMSTag() "{{{
  let curdir = getcwd()
  "" Setup for CMSSW
  if  !exists("$CMSSW_BASE") || match(curdir, expand("$CMSSW_BASE")) == -1 
    return 0
  endif
  set tags+=CMSTag

  while !filereadable("CMSTag") 
  "while !filereadable("CMSTag") && matchend(getcwd(), expand("$CMSSW_BASE")) != len(getcwd())
    cd ..
  endwhile
  let g:test = getcwd()

  if filereadable("CMSTag")
    set tags+=CMSTag
  endif

  execute "cd " . curdir
  return 1
endfunction "}}}
call SetCMSTag()


fun! s:PreviewSyn() "{{{
  if ! &pvw 
    return 0
  endi

  syn match CalLocation /cmd:.*$/hs=s+4
  syn match CalTemp /Temp:.*$/hs=s+5
  syn match CalCond /Cond:.*$/hs=s+5
  syn match CalWind /Wind:.*$/hs=s+5
  syn match CalHumidity /signature:.*$/hs=s+10
  hi link CalLocation Identifier
  hi link CalTemp Keyword
  hi link CalCond Define
  hi link CalWind Special
  hi link CalHumidity Todo
endfunction "}}}
autocmd BufWinEnter * call s:PreviewSyn()
