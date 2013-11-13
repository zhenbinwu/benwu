function! Powerline#Functions#syntastic#GetErrors(line_symbol) " {{{
	if ! exists('g:syntastic_stl_format')
		" Syntastic hasn't been loaded yet
		return ''
	endif

	" Temporarily change syntastic output format
	let old_stl_format = g:syntastic_stl_format
	let g:syntastic_stl_format = '%E{ ERRORS (%e) '. a:line_symbol .' %fe }%W{ WARNINGS (%w) '. a:line_symbol .' %fw }'

	let ret = SyntasticStatuslineFlag()

	let g:syntastic_stl_format = old_stl_format

	return ret
endfunction " }}}

"" I modify this function for both syntastic and asynccommand now since I use
"" async make brunch from syntastic
function! Powerline#Functions#syntastic#Enable() " {{{
	if ! exists('g:syntastic_stl_format') &&  ! exists('g:loaded_asynccommand')
		" Syntastic hasn't been loaded yet
		return ''
	endif
    
    let output = ''

    if exists('g:syntastic_enable') && g:syntastic_enable
      let output .= '§'
    else
      let output .= ''
    endif

    if exists('*asynccommand#powerline')
      let output .= asynccommand#powerline()
    endif

    return output
endfunction " }}}
