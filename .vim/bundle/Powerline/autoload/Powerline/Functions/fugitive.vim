function! Powerline#Functions#fugitive#GetDirtyBranch(symbol) " {{{
  if !exists("b:branch_sym")
    let b:branch_sym = a:symbol
  endif

  if !exists("b:branch_status")
    let b:branch_status = fugitive#filestatus()
  endif

  if b:branch_status == ''
    return ''
  endif

  let temp = split(b:branch_status, ' ')[0]
  if b:branch_status[0] == ' '
    let temp = '_'.temp
  endif

  if temp  == '_M' 
    let b:branch_sym = "✍ "
  elseif temp  == 'M' 
    let b:branch_sym = "☂ "
  elseif temp  == 'MM' 
    let b:branch_sym = "☔ "
  elseif temp  == '??' 
    let b:branch_sym = "☯ "
  elseif temp  == 'A' 
    let b:branch_sym = "⛃ "
  else
    let b:branch_sym = temp."|"
  endif

  let b:branch_ret = fugitive#statusline()

  let b:branch_ret = substitute(b:branch_ret, '\c\v\[?GIT\(([a-z0-9\-_\./:]+)\)\]?', b:branch_sym  .'\1', 'g')

  return b:branch_ret
endfunction " }}}

function! Powerline#Functions#fugitive#GetCleanBranch(symbol) " {{{
  let b:branch_status = fugitive#filestatus()

  if b:branch_status != ''
    return ''
  endif

  let b:branch_sym = a:symbol
  let b:branch_ret = fugitive#statusline()

  let b:branch_ret = substitute(b:branch_ret, '\c\v\[?GIT\(([a-z0-9\-_\./:]+)\)\]?', b:branch_sym  .' \1', 'g')

  if b:branch_ret =~ 'master'
    return ''
  else
    return b:branch_ret
  endif
endfunction " }}}
