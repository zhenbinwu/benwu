" this is mostly a matter of taste. but LaTeX looks good with just a bit
" of indentation.
set sw=2
" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
set iskeyword+=:

""By default, typing Alt-<key> in Vim takes focus to the menu bar if a menu
""with the hotkey <key> exists. If in your case, there are conflicts due to
""this behavior, you will need to set  >
set winaltkeys=no

""The Alt key is hard to map within Xterm. So I have to re-map other key 
imap <C-L> <Plug>Tex_LeftRight
imap <C-B> <Plug>Tex_MathBF
imap <C-D> <Plug>Tex_MathCal
imap <C-U> <Plug>Tex_InsertItemOnThisLine

"" imap .<CR> <C-R>set b:Imap_FreezeImap=1

fun! FreezeImap() "{{{
	if IMAP_GetVal('Imap_FreezeImap', 0) == 1
      let b:Imap_FreezeImap=0
    else 
      let b:Imap_FreezeImap=1
	endif
endfunction "}}}

imap <leader>i <ESC>:call FreezeImap()<CR>a
map <leader>i <ESC>:call FreezeImap()<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Some IMAP for HEP 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call IMAP(' wbb', ' $Wb\bar{b}$', 'tex')
call IMAP(' wcc', ' $Wc\bar{c}$', 'tex')
call IMAP(' ttbar', ' $t\bar{t}$', 'tex')

"let g:Tex_DefaultTargetFormat='pdf'
function! CheckBeamer() "{{{

	" For package files without \begin and \end{document}, we might be told to
	" search from beginning to end.
	if a:0 < 2
		0
		let beginline = search('\\begin{document}', 'W')
		let endline = search('\\end{document}', 'W')
		0
	else
		let beginline = a:1
		let endline = a:2
	endif

	" Scan the file. First open up all the folds, because the command
	" /somepattern
	" issued in a closed fold _always_ goes to the first match.
    let erm = v:errmsg
	silent! normal! ggVGzO
    let v:errmsg = erm

	" The wrap trick enables us to match \usepackage on the first line as
	" well.
	let wrap = 'w'
	while search('^\s*\\documentclass\_.\{-}{\_.\+}', wrap)
		let wrap = 'W'

		if line('.') > beginline 
			break
		endif

		let saveUnnamed = @"
		let saveA = @a

		" If there are options, then find those.
		if getline('.') =~ '\\documentclass\[.\{-}\]'
			let options = matchstr(getline('.'), '\\documentclass\[\zs.\{-}\ze\]')
		elseif getline('.') =~ '\\documentclass\['
			" Entering here means that the user has split the \usepackage
			" across newlines. Therefore, use yank.
            exec "normal! /{\<CR>\"ayi}"
			let options = @a
		else
			let options = ''
		endif

		" The following statement puts the stuff between the { }'s of a
		" \usepackage{stuff,foo} into @a. Do not use matchstr() and the like
		" because we can have things split across lines and such.
           exec "normal! f{\"ayiB\<CR>"

		" now remove all whitespace from @a. We need to remove \n and \r
		" because we can encounter stuff like
		" \usepackage{pack1,
		"             newpackonanotherline}
		let @a = substitute(@a, "[ \t\n\r]", '', 'g')

		" Now we have something like pack1,pack2,pack3 with possibly commas
		" and stuff before the first package and after the last package name.
		" Remove those.
		let @a = substitute(@a, '\(^\W*\|\W*$\)', '', 'g')

		" This gets us a string like 'pack1,pack2,pack3'
		" TODO: This will contain duplicates if the user has duplicates.
		"       Should we bother taking care of this?
		let b:Tex_package_detected = @a

		" Finally convert @a into something like '"pack1","pack2"'
		let @a = substitute(@a, '^\|$', '"', 'g')
		let @a = substitute(@a, ',', '","', 'g')

		" restore @a
		let @a = saveA
		let @" = saveUnnamed
	endwhile
    
    if exists("b:Tex_package_detected")
      if b:Tex_package_detected == 'beamer'
        let g:Tex_DefaultTargetFormat='pdf'
      else 
        let g:Tex_DefaultTargetFormat='dvi'
      endif
    endif
endfunction "}}}
call CheckBeamer()

" If buffer modified, update the date in the file
" Restores cursor and window position using save_cursor variable.
function! LastModified()
  if &modified
    let save_cursor = getpos(".")
    keepjumps exe '1,' . line("$") . 's#^\(\\date{\).*\(}\)#\1' .
          \ strftime('%b %d, %Y') . '\2#e'
    call histdel('search', -1)
    call setpos('.', save_cursor)
  endif
endfun
autocmd BufWritePre *.tex call LastModified()
