"this is mostly a matter of taste. but LaTeX looks good with just a bit
" of indentation.
set sw=2


""By default, typing Alt-<key> in Vim takes focus to the menu bar if a menu
""with the hotkey <key> exists. If in your case, there are conflicts due to
""this behavior, you will need to set  >
set winaltkeys=no


""The Alt key is hard to map within Xterm. So I have to re-map other key 
imap <C-L> <Plug>Tex_LeftRight
imap <C-B> <Plug>Tex_MathBF
imap <C-D> <Plug>Tex_MathCal
imap <C-U> <Plug>Tex_InsertItemOnThisLine

fun! FreezeImap() "{{{
	if IMAP_GetVal('Imap_FreezeImap', 0) == 1
      let b:Imap_FreezeImap=0
    else 
      let b:Imap_FreezeImap=1
	endif
endfunction "}}}

imap <leader>i <ESC>:call FreezeImap()<CR>a
map <leader>i <ESC>:call FreezeImap()<CR>

" Detect documentclass, let g:Tex_DefaultTargetFormat='pdf' if it is a beamer
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
function! LastModified() "{{{
  if &modified
    let save_cursor = getpos(".")
    keepjumps exe '1,' . line("$") . 's#^\(\\date{\).*\(}\)#\1' .
          \ strftime('%b %d, %Y') . '\2#e'
    call histdel('search', -1)
    call setpos('.', save_cursor)
  endif
endfun "}}}
autocmd BufWritePre *.tex call LastModified()

" Read in all the included file or package used, find out all the
" def and newcommand. Map the input 
" 
function! GetCustomLatexCommands() "{{{

" Don't run this for fugitive files
if expand ('%:p') =~? "^fugitive://.*.tex"
  return
endif

python << EOF
import os
import os.path
import re


def getCMD(line):
    commands = []
    if len(line) == 0 or line[0] == '%':
        return commands
    tmp = re.search(r"^\\def\\([^\{].*?)\s*{(.*?)}", line)
    if tmp != None:
        cmd = tmp.group(1)
        commands.append(cmd)
    tmp = re.search(r"^\\newcommand{\\(.*?)}\s*", line)
    if tmp != None:
        cmd = tmp.group(1)
        commands.append(cmd)
    return commands

def readFile(p):
    """Reads a file and extracts custom commands"""
    f = open(p)
    commands = []
    for _line in f:
        line = _line.strip()
        if re.search(r"\\begin{document}", line) != None:
            break;

        tmpCMD = getCMD(line)
        if tmpCMD != []:
            commands.append(tmpCMD)

        # search for included files
        tmp = re.search(r"(input|include){(.*)}", line)
        if tmp != None:
            path = tmp.group(2)
            newpath = os.path.join(os.path.dirname(p), path)
            if os.path.exists(newpath) and os.path.isfile(newpath):
                commands.extend(readFile(newpath))
            elif os.path.exists(newpath+".tex") and os.path.isfile(newpath+".tex"):
                commands.extend(readFile(newpath+".tex"))

        ## search for usepackage 
        #tmp = re.search(r"(usepackage){(.*)}", line)
        #if tmp != None:
        #    path = tmp.group(2)
        #    newpath = os.path.join(os.path.dirname(p), path)
        #    if os.path.exists(newpath) and os.path.isfile(newpath):
        #        commands.extend(readFile(newpath))
        #    elif os.path.exists(newpath+".tex") and os.path.isfile(newpath+".tex"):
        #        commands.extend(readFile(newpath+".tex"))
        #    elif os.path.exists(newpath+".sty") and os.path.isfile(newpath+".sty"):
        #        commands.extend(readFile(newpath+".sty"))

    return commands

def getMain(path, startingpoint = None):
    """Goes folders upwards until it finds a *.latexmain file"""
    if startingpoint==None:
        startingpoint = path
    files = []
    if os.path.isdir(path):
        files = os.listdir(path)
    files = [os.path.join(path, s) for s in files if s.split(".")[-1] == "latexmain"]
    if len(files) >= 1:
        return os.path.splitext(files[0])[0]
    if os.path.dirname(path) != path:
        return getMain(os.path.dirname(path), startingpoint)
    return startingpoint

def GetCustomLatexCommands():
    """Reads all custom commands and adds them to givm"""
    import vim
    cmds = readFile(getMain(vim.current.buffer.name))
    for cmd in cmds:
        if cmd[0].find('#') == -1:
            todo = 'iabbrev <buffer> {0} \{1}'.format(cmd[0], cmd[0])
            vim.command(todo)
            #vim.command("inoreabbrev %s \%s"%(cmd[0][0],cmd[0][0]))
            #vim.command('let g:Tex_Com_%s="\\\\%s%s <++>"'%(cmd, cmd, "{<++>}"*argc))

GetCustomLatexCommands()

EOF
endfunction "}}}

autocmd VimEnter,BufNewFile,BufRead *.tex :call GetCustomLatexCommands()

" Easy section jumping from http://vim.wikia.com/wiki/Section_jump_in_Latex
noremap <buffer> <silent> ]] :<c-u>call TexJump2Section( v:count1, '' )<CR>zvzz
noremap <buffer> <silent> [[ :<c-u>call TexJump2Section( v:count1, 'b' )<CR>zvzz
function! TexJump2Section( cnt, dir ) "{{{
  let i = 0
  let pat = '^\\\(part\|chapter\|\(sub\)*section\|paragraph\)\>\|\%$\|\%^'
  let flags = 'W' . a:dir
  while i < a:cnt && search( pat, flags ) > 0
    let i = i+1
  endwhile
  let @/ = pat
endfunction "}}}

" Tagbar support
let g:tagbar_type_tex = {
      \ 'ctagstype' : 'latex',
      \ 'kinds'     : [
      \ 's:sections',
      \ 'g:graphics:0:0',
      \ 'l:labels',
      \ 'r:refs:1:0',
      \ 'p:pagerefs:1:0'
      \ ],
      \ 'sort'    : 0,
      \ }

" Add more surround support for latex
" From cheat sheat, \textit{*} form handles spacing better then {\it *} form
let g:surround_{char2nr("t")} = "\\textit{\r}"
let g:surround_{char2nr("s")} = "\\textsc{\r}"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Some IMAP for HEP 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Abbreviate for my thesis
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iabbrev st     single top
iabbrev xs     cross section
iabbrev mc     Monte Carlo
iabbrev me     matrix element
iabbrev sm     Standard Model
iabbrev cdf    CDF
iabbrev tchan  $t$-channel
iabbrev schan  $s$-channel
iabbrev wtchan $Wt$-channel
iabbrev 2t2    2 $\to$ 2
iabbrev 2t3    2 $\to$ 3
iabbrev >      $>$
iabbrev <      $<$

