" Vim completion script
" Language:    R
" Maintainer:  Jakson Alves de Aquino <jalvesaq@gmail.com>
"

fun! rcomplete#CompleteR(findstart, base)
  if &filetype == "rnoweb" && RnwIsInRCode() == 0 && exists("*LatexBox_Complete")
      let texbegin = LatexBox_Complete(a:findstart, a:base)
      return texbegin
  endif
  if a:findstart
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && (line[start - 1] =~ '\w' || line[start - 1] =~ '\.' || line[start - 1] =~ '\$')
      let start -= 1
    endwhile
    return start
  else
    if b:needsnewomnilist == 1
      call BuildROmniList("GlobalEnv", "")
    endif
    let res = []
    if strlen(a:base) == 0
      return res
    endif

    if len(g:rplugin_liblist) == 0
        call add(res, {'word': a:base, 'menu': " [ List is empty. Run  :RUpdateObjList ]"})
    endif

    let flines = g:rplugin_liblist + g:rplugin_globalenvlines
    " The char '$' at the end of 'a:base' is treated as end of line, and
    " the pattern is never found in 'line'.
    let newbase = '^' . substitute(a:base, "\\$$", "", "")
    let s:count = 0
    for line in flines
      if line =~ newbase
        " Skip cols of data frames unless the user is really looking for them.
        if a:base !~ '\$' && line =~ '\$'
            continue
        endif
        let tmp1 = split(line, "\x06", 1)
        let info = tmp1[4]
        let info = substitute(info, "\t", ", ", "g")
        let info = substitute(info, "\x07", " = ", "g")
        if len(tmp1) > 5
          let info = "RFun: " . tmp1[5] . "\nRArg: " . info
        else
          if s:count < 15
            exe 'Py SendToVimCom("vim.help(' . "'" . tmp1[0] . "', 100)\")"
            if g:rplugin_lastrpl == "VIMHELP"
              let out = readfile(g:rplugin_docfile, '', 5)[2]
              let g:out = readfile(g:rplugin_docfile, '', 5)[2]
              let out = "RFun: " . substitute(out, "\_\x08", "", 'g')
              let info = out . "\nRArg: " . info
            endif
            let s:count += 1
          endif
        endif
        let tmp2 = {'word': tmp1[0], 'menu': tmp1[1] . ' ' . tmp1[3], 'info': info}
        call add(res, tmp2)
      endif
    endfor
    return res
  endif
endfun

autocmd BufWinEnter * if &pvw | syn match CalLocation /RFun:.*$/hs=s+5 | hi link CalLocation Identifier | endif


"set completefunc=CompleteR



