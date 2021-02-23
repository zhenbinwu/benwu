if !exists("$CMSSW_BASE")
  finish
endif

if match(expand("%:p:h"), expand("$CMSSW_BASE")) == -1 
  finish
endif

""" Set nice value and get the number of cores with nproc
let s:nicecmd = ''
let s:nuse = 0

"" Set the makeprg for the scram
fun! SetMakeprg() "{{{
  let b:tempdir = getcwd()

  execute "lcd " . expand("%:p:h")
  "" Check local Makefile
  let mkfile	= SearchFile("Makefile")  " try to find a Makefile
  if mkfile == ''
    let mkfile  = SearchFile("makefile") " try to find a makefile
  endif
  
  if s:nicecmd == ''
    if match("bash", expand("$SHELL")) != -1
      let s:nicecmd = "nice\\ -n\\ 19\\ "
    else
      let s:nicecmd = "nice\\ +19\\ "
    endif
  endif

  if s:nuse == 0
    let s:uname = system("uname")[:-2]
    let s:ncores = 0
    if !v:shell_error && s:uname == "Linux"
      let s:ncores = system("nproc")[:-2]
    elseif !v:shell_error && s:uname == "Darwin"
      let s:ncores = system("sysctl -n hw.ncpu")[:-2]
    endif
    let s:nuse = eval(s:ncores."/2")
  endif

  if mkfile != ''
    execute "lcd " . fnamemodify(mkfile, ":p:h")
    "execute "set makeprg=make"
    execute "set makeprg=". s:nicecmd . "make\\ -j\\ ". s:nuse
  else
    Glcd
    "execute "set makeprg=scram\\ build\\ -j\\ 4"
    execute "set makeprg=". s:nicecmd. "scram\\ build\\ -j\\ ".s:nuse
  endif

  lcd b:tempdir
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

""" Setup clang library
if exists("$CLANGPATH")
    let g:clang_library_path=expand("$CLANGPATH")
else
    let s:clang=substitute(split(system("scram tool info llvm-ccompiler"))[-2], "CC=", "","")
    let g:clang_library_path=substitute(s:clang, "bin/clang", "lib","")
    if !isdirectory(g:clang_library_path)
        let g:clang_library_path=substitute(s:clang, "bin/clang", "lib64","")
    endif
endif
