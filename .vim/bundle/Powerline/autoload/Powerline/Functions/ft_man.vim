function! Powerline#Functions#ft_man#GetName() " {{{
	let matches = matchlist(getline(1), '\v^([a-zA-Z_\.\-\:]+)')

	if ! len(matches)
		return 'n/a'
	endif

	let file = tolower(matches[1])

	return file
endfunction " }}}
