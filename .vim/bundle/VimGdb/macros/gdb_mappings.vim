" Mappings example for use with gdb
" Maintainer:	<xdegaye at users dot sourceforge dot net>
" Last Change:	Mar 6 2006

if ! has("gdb")
    finish
endif

if !exists("g:gdbvar_width")
  let g:gdbvar_width = 30
endif

let s:gdb_k = 1
let s:gdbvar_win_maximized = 0

" map vimGdb keys
nmap <F11> :call <SID>Toggle()<CR>


" Gdbvar_Window_Zoom
" Zoom (maximize/minimize) the gdbvar window
function! s:Gdbvar_Window_Zoom()
    if s:gdbvar_win_maximized
        " Restore the window back to the previous size
        exe 'vert resize ' . g:gdbvar_width
        let s:gdbvar_win_maximized = 0
    else
        " Set the window size to the maximum possible without closing other
        " windows
        vert resize
        let s:gdbvar_win_maximized = 1
    endif
endfunction


fun! s:Debug_File() "{{{
  let s:vimgdb_debug_file = ""
  let Exe  = "./".expand("%:r").".exe"
  let Run  = "./".expand("%:r")

  if executable(Exe) && !executable(Run)
    let s:vimgdb_debug_file = Exe
  endif
  if !executable(Exe) && executable(Run)
    let s:vimgdb_debug_file = Run
  endif

  if executable(Exe) && executable(Run)
    if getftime(Exe) >= getftime(Run) 
      let s:vimgdb_debug_file = Exe
    else
      let s:vimgdb_debug_file = Run
    endif
  endif
endfunction "}}}

" Toggle between vim default and custom mappings
function! s:Toggle()
  if s:gdb_k
    let s:gdb_k = 0

    if  !exists("g:vimgdb_debug_file")
      let g:vimgdb_debug_file = ""
    endif

    if g:vimgdb_debug_file == ""
      call s:Debug_File()
      call inputsave()
      if s:vimgdb_debug_file != ""
        let g:vimgdb_debug_file = input("File: ", s:vimgdb_debug_file ,"file")
      else
        let g:vimgdb_debug_file = input("File: ", "" ,"file")
      endif
      call inputrestore()
      call gdb("file ".  g:vimgdb_debug_file)
    endif


    let main = 0
    let w = 1
    while w <= winnr('$')
      if bufname(winbufnr(w)) == "gdb-variables" 
        let main = w
        break
      endif
      let w += 1
    endwhile

    if main == 0
      exec "silent belowright ". g:gdbvar_width . "vsplit gdb-variables"
      setlocal nonumber
      nnoremap <buffer> <silent> x :call <SID>Gdbvar_Window_Zoom()<CR>
    endif
    unlet w main


    map <Space> :call gdb("")<CR>
    nmap <silent> <C-Z> :call gdb("\032")<CR>

    nmap <silent> B :call gdb("info breakpoints")<CR>
    nmap <silent> L :call gdb("info locals")<CR>
    nmap <silent> A :call gdb("info args")<CR>
    nmap <silent> S :call gdb("step")<CR>
    nmap <silent> I :call gdb("stepi")<CR>
    nmap <silent> <C-N> :call gdb("next")<CR>
    nmap <silent> X :call gdb("nexti")<CR>
    nmap <silent> F :call gdb("finish")<CR>
    nmap <silent> R :call gdb("run")<CR>
    nmap <silent> Q :call gdb("quit")<CR>
    nmap <silent> C :call gdb("continue")<CR>
    nmap <silent> W :call gdb("where")<CR>
    nmap <silent> <C-U> :call gdb("up")<CR>
    nmap <silent> <C-D> :call gdb("down")<CR>

    " set/clear bp at current line
    nmap <silent> <C-B> :call <SID>Breakpoint("break")<CR>
    nmap <silent> <C-E> :call <SID>Breakpoint("clear")<CR>

    " print value at cursor
    nmap <silent> <C-P> :call gdb("print " . expand("<cword>"))<CR>

    " display Visual selected expression
    vmap <silent> <C-P> y:call gdb("createvar " . "<C-R>"")<CR>

    " print value referenced by word at cursor
    nmap <silent> <C-X> :call gdb("print *" . expand("<cword>"))<CR>

    " display value at cursor
    nmap <silent> <C-A> :call gdb("createvar " . expand("<cword>"))<CR>

    " display value referenced by word at cursor 
    " M stand for in memory :-)
    nmap <silent> <C-M> :call gdb("createvar *" . expand("<cword>"))<CR>

    " Open Tag List 
    nmap <silent> <F12> :TlistToggle<CR>
    map <silent> <leader>gdb :call <SID>ExitGdb()<CR>

    if exists("g:tagbar_left")
      let s:tagbar_left = g:tagbar_left
      let g:tagbar_left = 1
    endif

    if exists("g:tagbar_width")
      let s:tagbar_width = g:tagbar_width
      let g:tagbar_width = 30
    endif

    let s:winNo = bufwinnr(s:bufNo)
    exec s:winNo . "wincmd w"

    echohl ErrorMsg
    echo "gdb keys mapped"
    echohl None

    "let s:winNo = bufwinnr(s:bufNo)
    "exec s:winNo . "wincmd w"

    " Restore vim defaults
  else
    let s:gdb_k = 1
    nunmap  <Space>
    nunmap <C-Z>

    nunmap B
    nunmap L
    nunmap A
    nunmap S
    nunmap I
    nunmap <C-N>
    nunmap X
    nunmap F
    nunmap R
    nunmap Q
    nunmap C
    nunmap W
    nunmap <C-U>
    nunmap <C-D>

    nunmap <C-B>
    nunmap <C-E>
    nunmap <C-P>
    vunmap <C-P>
    nunmap <C-X>
    nunmap <C-A>
    nunmap <C-M>
    map <silent> <leader>gdb :call <SID>ExitGdb()<CR>

    echohl ErrorMsg
    echo "gdb keys reset to default"
    echohl None
  endif
endfunction

" Run cmd on the current line in assembly or symbolic source code
" parameter cmd may be 'break' or 'clear'
function! s:Breakpoint(cmd)
    " An asm buffer (a 'nofile')
    if &buftype == "nofile"
	" line start with address 0xhhhh...
	let s = substitute(getline("."), "^\\s*\\(0x\\x\\+\\).*$", "*\\1", "")
	if s != "*"
	    call gdb(a:cmd . " " . s)
	endif
    " A source file
    else
	let s = "\"" . fnamemodify(expand("%"), ":p") . ":" . line(".") . "\""
	call gdb(a:cmd . " " . s)
    endif
endfunction

let s:bufNo = bufnr("%")
call s:Toggle()

function! s:ExitGdb()
    let s:bufNo = bufnr("gdb-variables")
    exec s:bufNo . "bdelete"
    call gdb("quit")
    let s:gdb_k = 0
    call s:Toggle()
    let g:vimgdb_debug_file = ""
    map <silent> <leader>gdb :run macros/gdb_mappings.vim<CR>
    map <silent> <F12> :WMToggle<CR>

    if exists("g:tagbar_left")
      let g:tagbar_left = s:tagbar_left 
    endif

    if exists("g:tagbar_width")
      let g:tagbar_width = s:tagbar_width 
    endif

    redraw!
endfunction

