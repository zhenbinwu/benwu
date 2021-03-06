map  <buffer> <F5> :call Runexe()<CR>
map  <buffer> <F6> :call Showexe()<CR>
map  <buffer> <leader>rr :update<cr>:!root -l  %<CR>
imap <buffer> <leader>rr <Esc>:update<CR>:!root -l  %<CR>
map  <buffer> <leader>dd :g/\(.*__func__.*\\|.*__FILE__.*\\|.*__LINE__.*\)\+/d<cr>:nohl<cr>

nnoremap <buffer> <silent> ]/  :call search('^.*//.*$', 'W')<CR>zvz.
nnoremap <buffer> <silent> [/ 0:call search('^.*//.*$', 'bW')<CR>zvz.

fun! Runexe() "{{{
  "if exists("g:cpp_run") && g:cpp_run != "" && executable("./".g:cpp_run)
  if exists("g:cpp_run") && g:cpp_run != "" 
    exe "!".g:cpp_run
    return 
  endif

  let Exe  = "./".expand("%:r").".exe"
  let Run  = "./".expand("%:r")
  if executable(Exe) && !executable(Run)
    exe		"!".Exe
    return 
  endif
  if !executable(Exe) && executable(Run)
    exe		"!".Run
    return 
  endif

  if executable(Exe) && executable(Run)
    if getftime(Exe) >= getftime(Run) 
      exe		"!".Exe
      return 
    else
      exe		"!".Run
      return 
    endif
  endif

  if !executable(Exe) && !executable(Run)
    let exefiles = glob("`find . -executable -type f`")
    let exelist = split(exefiles, '\n')
    for i in range(len(exelist))
      if match(exelist[i], '.so') != -1
        unlet exelist[i]
      endif
    endfor
    if len(exelist) == 1
      exe '!'.exelist[0]
      return 
    endif
  endif

  if exists("g:cpp_run") && g:cpp_run != ""
    echo g:cpp_run . " is not found! Please setup the correct file name."
  else
    echo "No executable assign! Can manually set g:cpp_run"
  endif
endfunction "}}}

fun! Showexe() "{{{
  if exists("g:cpp_run") && g:cpp_run != "" && executable("./".g:cpp_run)
    call inputsave()
    let name = input(':!'.g:cpp_run.' ')
    call inputrestore()
    let ExeSrc = ":!".g:cpp_run." ".name
    exe         ExeSrc
    return 
  endif

  let Exe  = "./".expand("%:r").".exe"
  let Run  = "./".expand("%:r")
  if executable(Exe) && !executable(Run)
    call inputsave()
    let name = input(':!'.Exe.' ')
    call inputrestore()
    let ExeSrc = ":!".Exe." ".name
    exe         ExeSrc
    return 
  endif

  if !executable(Exe) && executable(Run)
    call inputsave()
    let name = input(':!'.Run.' ')
    call inputrestore()
    let RunSrc = ":!".Run." ".name
    exe         RunSrc
    return
  endif

  if executable(Exe) && executable(Run)
    if getftime(Exe) >= getftime(Run) 
      call inputsave()
      let name = input(':!'.Exe.' ')
      call inputrestore()
      let ExeSrc = ":!".Exe." ".name
      exe         ExeSrc
      return
    else
      call inputsave()
      let name = input(':!'.Run.' ')
      call inputrestore()
      let RunSrc = ":!".Run." ".name
      exe         RunSrc
      return
    endif
  endif

  if !executable(Exe) && !executable(Run)
    let exefiles = glob("`find . -executable -type f`")
    let exelist = split(exefiles, '\n')
    for i in range(len(exelist))
      if match(exelist[i], '.so') != -1
        unlet exelist[i]
      endif
    endfor
    if len(exelist) == 1
      call inputsave()
      let name = input(':!'.exelist[0].' ')
      call inputrestore()
      let ExeSrc = ":!".exelist[0]." ".name
      exe         ExeSrc
      return
    endif
  endif

  if exists("g:cpp_run") && g:cpp_run != ""
    echo g:cpp_run . " is not found! Please setup the correct file name."
  else
    echo "No executable assign! Can manually set g:cpp_run"
  endif
endfunction "}}}

fun! SyntasticCppC() "{{{
  "============================================================================"
  "                        Set all the variables needed                        "
  "============================================================================"
  let s:lrfiles  = {}
  let s:paths    = ['./']
  let s:d_paths  = {}
  let s:type     = &filetype
  let s:includes = {}
  let s:syntastic_cpp_includes = ''
  let s:syntastic_cpp_compiler_options = ''

  let s:library  = { "root" : {"pattern": '^T.*\.\(h\|hpp\)',    
        \                      "include": "s:SyntasticCppC_Root",
        \                      "cflags" : "s:SyntasticCppC_Root"}, 
        \           "boost" : {"pattern": "^boost.*", 
        \                      "include": "s:SyntasticCppC_Boost",
        \                      "cflags" : "s:SyntasticCppC_Boost"},
        \           "c11"   : {"pattern": '^\(cstdbool\|cstdint\|cuchar\|cwchar\|cwctype\|
        \                                 array\|forward_list\|unordered_map\|unordered_set\|
        \                                 chrono\|codecvt\|initializer_list\|random\|ratio\|
        \                                 regex\|system_error\|tuple\|type_traits\)\(\|\.h\)',
        \                      "include": "s:SyntasticCppC_C11",
        \                      "cflags" : "s:SyntasticCppC_C11"}
        \}

  "============================================================================"
  "                 Get the search path from g:alternativepath                 "
  "============================================================================"
  "" The search path
  let sp = split(g:alternateSearchPath, ",")
  for pathsec in sp
    let type = strpart(pathsec, 0, 3)
    let pth = strpart(pathsec, 4)
    if type == 'sfr'
      if pth == 'WHAM'
        let pth = split(expand("%:p:h"), '/')[-1]
      endif
      if isdirectory(expand('%:p:h'). "/" . pth)
        let s:d_paths[expand('%:p:h'). "/" . pth] = 1
      endif
    endif
    if type == 'reg'
      let sep = strpart(pth, 0, 1)
      let patend = match(pth, sep, 1)
      let pat = strpart(pth, 1, patend - 1)
      let subend = match(pth, sep, patend + 1)
      let sub = strpart(pth, patend+1, subend - patend - 1)
      let flag = strpart(pth, strlen(pth) - 2)
      if (flag == sep)
        let flag = ''
      endif
      if sub == 'WHAM'
        let sub = split(expand("%:p:h"), '/')[-2]
      endif
      if pat == 'WHAM'
        let pat = split(expand("%:p:h"), '/')[-2]
      endif
      let path = substitute(expand('%:p:h'), pat, sub, flag)

      if path != expand('%:p:h') && isdirectory(path)
        let s:d_paths[path] = 1
      endif
    endif
  endfor
  let s:paths += keys(s:d_paths)

  let lines = filter(getline(1, 50), 'v:val =~# "^\s*#\s*include"')
  call s:GetLRFiles(lines)

  "============================================================================"
  "                            Search current buffer                           "
  "============================================================================"
  call s:GetInclude()

  "return includes
endfunction "}}}

fun! s:GetLRFiles(lines) "{{{
  " search current buffer
  let lcfiles = []
  for line in a:lines
    let file = matchstr(line, '"\zs\S\+\ze"')
    if file != ''
      call add(lcfiles, file)
      continue
    endif

    let file = matchstr(line, '<\zs\S\+\ze>')
    if file != ''
      if has_key(s:lrfiles, file)
        let s:lrfiles[file] += 1
      else
        let s:lrfiles[file] = 1
      endif
      continue
    endif
  endfor

  "" search included headers
  for hfile in lcfiles
    if hfile == ''
      continue
    endif
    let sep = (has('win32') || has('win64')) ?  '\' : '/' 
    let found = 0
    for path in s:paths
      let filename = path . sep . hfile
      try
        let lines = readfile(filename, '', 100)
      catch /E484/
        continue
      endtry

      "" Add local include
      if path != './'
        let include = ' -I' . path . ''
        if has_key(s:includes, include)
          let s:includes[include] += 1
        else
          let s:includes[include] = 1
        endif
      endif

      let lines = filter(lines, 'v:val =~# "^\s*#\s*include"')
      let found = 1
      call s:GetLRFiles(lines)
    endfor
    
    if found == 0
      if has_key(s:lrfiles, hfile)
        let s:lrfiles[hfile] += 1
      else
        let s:lrfiles[hfile] = 1
      endif
    endif
  endfor
endfunction "}}}

fun! s:GetInclude() "{{{
  let s:syntastic_cpp_includes .= join(keys(s:includes))
  for [key, value] in items(s:library)
    if match(keys(s:lrfiles), value["pattern"]) != -1
      let s:syntastic_cpp_includes .= call(value["include"], ["include"])
      let s:syntastic_cpp_compiler_options .= call(value["cflags"], ["cflags"])
    endif
  endfor
  exec "let b:syntastic_" . &filetype . "_includes = s:syntastic_cpp_includes"
  exec "let b:syntastic_" . &filetype . "_cflags   = s:syntastic_cpp_compiler_options"
endfunction "}}}

fun! s:SyntasticCppC_Root(mode) "{{{
  if !executable("root-config")
    return ""
  endif
  if a:mode == "include"
    return " -I" . substitute(system("root-config --incdir"), '\n', ' ', '')
  elseif a:mode == "cflags"
    return ""
    "return system("root-config --cflags")
  endif
endfunction "}}}

fun! s:SyntasticCppC_C11(mode) "{{{
  if a:mode == "include"
    return ""
  elseif a:mode == "cflags"
    return " -std=c++0x"
  endif
endfunction "}}}

fun! s:SyntasticCppC_Boost(mode) "{{{
  if a:mode == "include"
    return " -I/usr/include/"
  elseif a:mode == "cflags"
    return ""
  endif
endfunction "}}}

"set tags+=~/.vim/ftplugin/cpp/cpp_tags
"set tags+=~/.vim/ftplugin/cpp/root_tags
"set tags+=~/.vim/ftplugin/cpp/boost_tags
"if executable("root-config")
  "let g:clang_user_options = split(system("root-config --cflags"))[-1]
"endif

set errorformat+=collect2:\ %m
