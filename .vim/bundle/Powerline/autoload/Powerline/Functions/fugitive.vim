function! Powerline#Functions#fugitive#GetBranch(symbol) " {{{
	let ret = fugitive#statusline()

	let ret = substitute(ret, '\c\v\[?GIT\(([a-z0-9\-_\./:]+)\)\]?', a:symbol .' \1', 'g')

    if ret =~ 'master'
      return ''
    else
      return ret
    endif
endfunction " }}}
