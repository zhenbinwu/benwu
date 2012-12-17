map  <buffer> <F5> :call Runexe()<CR>
map  <buffer> <F6> :call Showexe()<CR>
map  <buffer> <leader>rr :w<cr>:!root -l  %<CR>
imap <buffer> <leader>rr <Esc>:w<CR>:!root -l  %<CR>
map  <buffer> <leader>dd :g/.*__func__.*__FILE__.*__LINE__.*/d<cr>:nohl<cr>

nnoremap <buffer> <silent> ]/  :call search('^.*//.*$', 'W')<CR>zvz.
nnoremap <buffer> <silent> [/ 0:call search('^.*//.*$', 'bW')<CR>zvz.

fun! Runexe() "{{{
  let Exe  = "./".expand("%:r").".exe"
  let Run  = "./".expand("%:r")
  if executable(Exe) && !executable(Run)
    exe		"!".Exe
  endif
  if !executable(Exe) && executable(Run)
    exe		"!".Run
  endif

  if executable(Exe) && executable(Run)
    if getftime(Exe) >= getftime(Run) 
      exe		"!".Exe
    else
      exe		"!".Run
    endif
  endif
endfunction "}}}

fun! Showexe() "{{{
  let Exe  = "./".expand("%:r").".exe"
  let Run  = "./".expand("%:r")
  if executable(Exe) && !executable(Run)
    call inputsave()
    let name = input(':!'.Exe.' ')
    call inputrestore()
    let ExeSrc = ":!".Exe." ".name
    exe         ExeSrc
  endif
  if !executable(Exe) && executable(Run)
    call inputsave()
    let name = input(':!'.Run.' ')
    call inputrestore()
    let RunSrc = ":!".Run." ".name
    exe         RunSrc
  endif

  if executable(Exe) && executable(Run)
    if getftime(Exe) >= getftime(Run) 
      call inputsave()
      let name = input(':!'.Exe.' ')
      call inputrestore()
      let ExeSrc = ":!".Exe." ".name
      exe         ExeSrc
    else
      call inputsave()
      let name = input(':!'.Run.' ')
      call inputrestore()
      let RunSrc = ":!".Run." ".name
      exe         RunSrc
    endif
  endif
endfunction "}}}

fun! SyntasticCppC() "{{{
  "============================================================================"
  "                        Set all the variables needed                        "
  "============================================================================"
  let s:lrfiles  = {}
  let s:paths    = ['./']
  let s:type     = &filetype
  let s:includes = {}
  let s:syntastic_cpp_includes = ''
  let s:syntastic_cpp_compiler_options = ''
  exec "let b:syntastic_" . &filetype . "_includes = ''"
  exec "let g:syntastic_" . &filetype . "_compiler_options = ''"

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
    let pth = strpart(pathsec, 4)
    if isdirectory(expand('%:p:h'). "/" . pth)
      call add(s:paths, pth)
    endif
  endfor

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
      let filename = expand('%:p:h') . sep . path . sep . hfile
      try
        let lines = readfile(filename, '', 100)
      catch /E484/
        continue
      endtry

      "" Add local include
      if path != './'
        if expand("%:h") == '.'
          let include = ' -I' . path . ''
        else 
          let include = ' -I' . expand("%:h") . sep . path . ''
        endif
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
  "echo s:syntastic_cpp_includes 
  "echo s:syntastic_cpp_compiler_options
  exec "let b:syntastic_" . &filetype . "_includes = s:syntastic_cpp_includes"
  exec "let g:syntastic_" . &filetype . "_compiler_options = s:syntastic_cpp_compiler_options"
endfunction "}}}

fun! s:SyntasticCppC_Root(mode) "{{{
  if !executable("root-config")
    return ""
  endif
  if a:mode == "include"
    return " -I" . system("root-config --incdir")
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

set tags+=~/.vim/ftplugin/cpp/cpp_tags
"set tags+=~/.vim/ftplugin/cpp/boost_tags
