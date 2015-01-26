if !exists("$CMSSW_BASE")
  finish
endif

if match(expand("%:p:h"), expand("$CMSSW_BASE")) == -1 
  finish
endif

"" Set the makeprg for the scram
fun! SetMakeprg() "{{{
  "" Setup for CMSSW
  "execute "set makeprg=scram\\ build\\ -j\\ 8\\ CXX='~/.vim/bundle/ClangComplete/bin/cc_args.py\\\\\\ ".tempcxx."'"
  let b:tempdir = getcwd()
  Glcd
  """ Set nice value and get the number of cores with nproc
  let nicecmd = ""
  if match("bash", expand("$SHELL")) != -1
    let nicecmd = "nice\\ -n\\ 19\\ "
  else
    let nicecmd = "nice\\ +19\\ "
  endif
  let ncores = system("nproc")
  execute "set makeprg=" . nicecmd . "scram\\ build\\ -j\\ " . ncores
  lcd b:tempdir
  let g:UpdateMake = 1
endfunction "}}}

"" Preview syntax for Clang
fun! s:PreviewSyn() "{{{
  if ! &pvw 
    return 0
  endif
  syn match CppFunc	"\%^[^/].*" skipnl
  syn match CppReturn /Return:.*$/hs=s+7
  syn match CppComment "//.*"
  hi link CppFunc Define
  hi link CppReturn Keyword
  hi link CppComment Special
endfunction "}}}
autocmd BufWinEnter * call s:PreviewSyn()

set completeopt+=preview

map <F4> <Esc>:call MapMake(0, 1)<CR>

"" Setup clang library
"" BUG: The CMSSW libclang will crash the clang_complete
"
if( match(hostname(), 'cmslpc') >=0 )
  let s:clang=substitute(split(system("scram tool info llvm-ccompiler"))[-2], "CC=", "","")
  let g:clang_library_path=substitute(s:clang, "bin/clang", "lib","")
endif
