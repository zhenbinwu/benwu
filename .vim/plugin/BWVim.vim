"" File Description {{{
" =============================================================================
" This script is mainly strip from my vimrc. It contains some functions for
" various vim component aiming for smarter support during editing.
" 1. TabLine and TabLabel
" 2. Make, QuickFix & LocalList
"                                                  by Ben Wu
"                                                     benwu@fnal.gov
" Usage : Load this vim script
"
" =============================================================================
" }}}


"============================================================================"
"                                   TabLine                                  "
"============================================================================"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display tab number in tabline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! MyTabLine()"{{{
  let s = ''
  let t = tabpagenr()
  let i = 1
  while i <= tabpagenr('$')
    let buflist = tabpagebuflist(i)
    let winnr = tabpagewinnr(i)
    let s .= '%' . i . 'T'
    let s .= (i == t ? '%1*' : '%2*')
    let s .= ' '
    let s .= i . ':'
    "let s .= winnr . '/' . tabpagewinnr(i,'$')
    "let s .= tabpagewinnr(i,'$')
    let bufnr = buflist[winnr - 1]
	let s .= bufnr
    let s .= ' %*'
    let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
    if getbufvar(bufnr, "&modified")
      let s .= '+'
    endif
    let file = bufname(bufnr)
    let buftype = getbufvar(bufnr, 'buftype')
    if file == ''
      if buftype == 'quickfix'
	let file = '[Quickfix List]'
      else
	let file = '[No Name]'
      endif
    else
      let file = fnamemodify(file, ':t')
    endif
    let s .= file
    let i = i + 1
  endwhile
  let s .= '%T%#TabLineFill#%='
  let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
  return s
endfunction"}}}

set tabline=%!MyTabLine()

set guitablabel=%N\|%n\ %M%t
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map for switching between the last two tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
au TabLeave * :let g:last_tab=tabpagenr()
function! <sid>LastTab()"{{{
  if !exists("g:last_tab")
    return
  endif
  exe "tabn" g:last_tab
endfu"}}}

nmap <silent> <leader>tt :call <sid>LastTab()<CR>


"============================================================================"
"                            QuickFix & LocalList                            "
"============================================================================"
fun! s:SetMakeprg() "{{{
  "" Setup for CMSSW
  if  exists("$CMSSW_BASE") && match(expand("%:p:h"), expand("$CMSSW_BASE")) != -1 && executable("scram")
    set makeprg =scram\ b\ -j\ 8
  endif
  return 1
endfunction "}}}

"" Re-define make
let g:make_target = "%:r"
fun! MapMake(output) "{{{
  silent %s/<##>//eg
  if exists("g:syntastic_enable") 
    let syntastic_temp = g:syntastic_enable
    if g:syntastic_enable == 1
      let g:syntastic_enable = 0
    endif
  endif

  if exists("g:UpdateMake")
  else
    if (&filetype == 'c' || &filetype == 'cpp')
      call s:SetMakeprg()
    endif
    let g:UpdateMake = 1
  endif

  w
  if a:output == 0
    silent make
  elseif a:output == 1
    execute "silent make " . g:make_target
  endif
  botright cwindow
  cc
  if exists("g:syntastic_enable") && exists("syntastic_temp")
    let g:syntastic_enable = syntastic_temp
  endif
  redraw!
endfunction "}}}

map <F2> <Esc>:call MapMake(0)<CR>
map <F3> <Esc>:call MapMake(1)<CR>
imap <F2> <Esc>:call MapMake(0)<CR>
imap <F3> <Esc>:call MapMake(1)<CR>

"" Automatic select local list or quickfix depending 
fun! QLstep(direction) "{{{
  hi GreenBar term=reverse ctermfg=white ctermbg=darkgreen guifg=white guibg=darkgreen
  let wnr = winnr()
  let llength = len(getloclist(wnr))
  if a:direction == 1
    if llength > 0
      try
        silent lnext!
        exec "normal zv"
      catch /E553/
        echohl WarningMsg
        echomsg "End of list"
        echohl None
      catch /E42/
        echohl GreenBar
        echomsg "No Errors"
        echohl None
      finally 
        return
      endtry
    else
      try
        silent cnext!
        exec "normal zv"
      catch /E553/
        echohl WarningMsg
        echomsg "End of list"
        echohl None
      catch /E42/
        echohl GreenBar
        echomsg "No Errors"
        echohl None
      finally 
        return
      endtry
    endif
  elseif a:direction == -1
    if llength > 0
      try
        silent lprevious!
        exec "normal zv"
      catch /E553/
        echohl WarningMsg
        echomsg "End of list"
        echohl None
      catch /E42/
        echohl GreenBar
        echomsg "No Errors"
        echohl None
      finally 
        return
      endtry
    else
      try
        silent cprevious!
        exec "normal zv"
      catch /E553/
        echohl WarningMsg
        echomsg "End of list"
        echohl None
      catch /E42/
        echohl GreenBar
        echomsg "No Errors"
        echohl None
      finally 
        return
      endtry
    endif
  endif
endfunction "}}}

map <F7> <Esc>:call QLstep(-1)<CR>
map <F8> <Esc>:call QLstep(1)<CR>
imap <F7> <Esc>:call QLstep(-1)<CR>
imap <F8> <Esc>:call QLstep(1)<CR>

"" Indicate weather the compiling is completed successfully!
function! QfMakeConv() "{{{
  if empty(getqflist())
    return
  endif

  let qflist_end = getqflist()[-1]['text']
  for igndir in split(g:qflist_done, ", ")
    if match(qflist_end, " ".igndir."$") != -1
      let g:qflist_result = "Success"
      break
    endif
  endfor
endfunction "}}}

au QuickFixCmdPre  make let g:qflist_result = ''
au QuickFixCmdPost make call QfMakeConv()

"" Ajust the window height for quickfix
function! s:AdjustWindowHeight(minheight, maxheight) "{{{
  exe max([min([line("$")+1, a:maxheight]), a:minheight]) . "wincmd _"
endfunction "}}}
au FileType qf call s:AdjustWindowHeight(3, 10)

"" Local mapping for quickfix
fun! s:QuickfixZoom() "{{{
  if g:quickfix_win_maximized
    " Restore the window back to the previous size
    exe 'resize ' . g:quickfix_win_height
    let g:quickfix_win_maximized = 0
  else
    " Set the window size to the maximum possible without closing other
    " windows
    resize
    let g:quickfix_win_maximized = 1
  endif
endfunction "}}}

fun! s:QuickfixSplit(mode) "{{{
  let s:qf_buf = bufnr("%")
  wincmd p

  if a:mode == 's'
    split
  endif
  if a:mode == 'v'
    vertical split
  endif

  echo bufwinnr(s:qf_buf) . "wincmd w"
  execute bufwinnr(s:qf_buf) . "wincmd w"
  normal 
endfunction "}}}

au FileType qf let g:quickfix_win_height = winheight(0)
au QuickFixCmdPre * let g:quickfix_win_maximized = 0
au FileType qf nnoremap <buffer> <silent> x :call <SID>QuickfixZoom()<CR>
au FileType qf nnoremap <buffer> <silent> s :call <SID>QuickfixSplit('s')<CR>
au FileType qf nnoremap <buffer> <silent> v :call <SID>QuickfixSplit('v')<CR>
au FileType qf nnoremap <buffer> <silent> q :q<CR>

"" Substitute long path name in quickfix window
fun! s:QuickfixSed() "{{{
    setlocal modifiable
    try
      "silent! %s#/home/benwu#$HOME#g
      exec "silent! %s#".getcwd()."#\.#g"
      silent! %s#/mnt/autofs/misc/nbay05.a/benwu/WHAM_CDF/#WHAM/#g
    catch /.*/
    endtry
    setlocal nomodifiable
    setlocal nomodified
endfunction "}}}
au FileType qf call s:QuickfixSed()

"" Exit vim when the last window is quickfix
function! MyLastWindow() "{{{
  " if the window is quickfix go on
  if &buftype=="quickfix"
    " if this window is last on screen quit without warning
    "if winbufnr(2) == -1
    if winnr('$') < 2
      quit
    endif
  endif
endfunction "}}}
au BufEnter * call MyLastWindow()

"============================================================================"
"                            General Functions                               "
"============================================================================"
" Highlight the repeated line
function! HighlightRepeats() range "{{{
  let lineCounts = {}
  let lineNum = a:firstline
  while lineNum <= a:lastline
    let lineText = getline(lineNum)
    if lineText != ""
      let lineCounts[lineText] = (has_key(lineCounts, lineText) ? lineCounts[lineText] : 0) + 1
    endif
    let lineNum = lineNum + 1
  endwhile
  exe 'syn clear Repeat'
  call setloclist(0, [])
  for lineText in keys(lineCounts)
    if lineCounts[lineText] >= 2
      exe 'syn match Repeat "^' . escape(lineText, '".\^$*[]') . '$"'
      echo 'grepadd "^' . escape(lineText, '".\^$*[]') . '$" %'
      exe 'silent! lgrepadd -x "' . escape(lineText, '".\^$*[]') . '" %'
    endif
  endfor
  if len(getloclist(0)) > 0
    lopen
    ll
    redraw!
  endif
endfunction "}}}

command! -range=% HighlightRepeats <line1>,<line2>call HighlightRepeats()

" mapping for google the word under cursor
function! s:OnlineDoc(word) "{{{
  let s:wordUnderCursor = a:word
  let s:ask = "What to google: " 
  let s:string = input(s:ask, s:wordUnderCursor . " ")
  let s:string = substitute(s:string, " ", "+", "g")
  let s:string = substitute(s:string, "+*$", "", "g")

  call s:OnlineWord(s:string)
endfunction "}}}

fun! s:OnlineWord(word) "{{{
  let s:browser = "opera"
  "let s:browser = "gnome-open"
  "
  let s:word = substitute(a:word, " ", "+", "g")
  let s:word = substitute(s:word, "+*$", "", "g")
  
  let s:url = "http://www.google.com/search?q=" . s:word . "\""
  let s:cmd ="silent ! " . s:browser . " \"" . s:url
  execute s:cmd
  redraw!
endfunction "}}}

nmap go :call <SID>OnlineWord(expand("<cword>"))<CR>
vmap go :call <SID>OnlineWord(expand("<C-R>*"))<CR>
nmap gO :call <SID>OnlineDoc(expand("<cword>"))<CR>
vmap gO :call <SID>OnlineDoc(expand("<C-R>*"))<CR>


"============================================================================"
"                        Run command using Asyncommand                       "
"============================================================================"

let g:AsynRun_path = "."
let g:AsynRun_comd = ""

function! AsynRunFunc() "{{{
  if !exists("g:loaded_asynccommand") 
    echo "Please install Asyncommand plugin!"
    return
  endif

  if v:servername == ''
    echo "Please start vim with a servername!"
    return
  endif

  if g:AsynRun_comd == ''
    if executable(expand(g:make_target))
      let g:AsynRun_comd = './' . expand(g:make_target)
    endif
  endif

  let cmd = 'cd ' .  g:AsynRun_path  . ";"
  let cmd .= g:AsynRun_comd
  let env = {}
  function env.get(temp_file) dict
    if self.return_code == 0
      " use tiny split window height on success
    endif

    if bufwinnr(bufnr('\[Asyn Run\]')) != -1
      let s:hasansi = "true"
      exec bufwinnr(bufnr('\[Asyn Run\]')) . "wincmd w" 
      setlocal modifiable
      normal GVgg"_d<C-[>
      exec "read " . a:temp_file
      exec "bwipeout " . a:temp_file
    else
      " open the file in a split
      exec 10 . "split " . "\[Asyn Run\]"
      exec "read " . a:temp_file
      exec "bwipeout " . a:temp_file

      if exists("g:loaded_AnsiEscPlugin") && !exists("b:AnsiEsc")
        setlocal conceallevel=3 
        AnsiEsc
      endif

      nnoremap <buffer> <silent> x  \|:silent exec 'resize '.( winheight('.') > 10 ? 10 : (winheight('.') + 100))<CR>
      nnoremap <buffer> <silent> q  :q<CR>


      setlocal buftype=nofile
      setlocal bufhidden=hide
      setlocal winfixheight
      setlocal noswapfile
      setlocal nobuflisted

    endif
    " remove boring build output
    "%s/^\[xslt\].*$/
    execute "silent! %s/]2;/[31;4mENV[m /g"
    execute "silent! %s//\r/g"
    setlocal number
    setlocal nomodified
    setlocal nomodifiable

    " go back to the previous window

    wincmd p
  endfunction

  " tab_restore prevents interruption when the task completes.
  " All provided asynchandlers already use tab_restore.
  call asynccommand#run(cmd, asynccommand#tab_restore(env))
endfunction "}}}

if has("clientserver") 
  nnoremap <silent> <leader>ar :call AsynRunFunc()<CR><Esc>
endif

"============================================================================"
"                        Run command in another screen window                "
"============================================================================"
let g:ScreenRun_winu = '1'
let g:ScreenRun_path = '.'
"let g:ScreenRun_comd = 'ls'
let g:ScreenRun_comd = 'ping gogle.com'
let g:ScreenRun_logp = '.'
"let g:ScreenRun_logp = '/home/benwu/temp/automake/'
"let g:ScreenRun_comd = '$LASTJOB'

fun! ScreenRunFunc() "{{{
  if match($TERM, "screen") == -1
    echo "This command only run within screen!"
    return
  endif

  "[*] Within vim, send command to another window within current screen section
  "set a variable for the current window and remove such screenlog
  "screen -p 0 -X stuff 'ls'`echo -n '\015'`
  "-n for tcsh, -ne for bash
  "screen -p 0 -X log (to start, again to stop)
  "setlocal autoread, autocmd to ansiesc

  "" Set all the inputs 
  if g:ScreenRun_winu == ''
    let g:ScreenRun_winu = inputdialog("Which window to run on? ", '0')
  endif
  
  if g:ScreenRun_path != '' && g:ScreenRun_path != './'  && g:ScreenRun_path != '.'
    let g:ScreenRun_path = inputdialog("Which path to run on? ", getcwd())
  endif

  if g:ScreenRun_comd == '' 
    let g:ScreenRun_comd = inputdialog("Which command to run? ", '')
  endif

  if $SHELL == 'tcsh'
    let enter = "`echo -n \'\\015\'`"
  else
    let enter = "`echo -ne \'\\015\'`"
  endif

"============================================================================"
"                          Clean the screenlog first                         "
"============================================================================"
  "" Start to constuct the command to run on
  if !exists("g:ScreenRun_first") || g:ScreenRun_first != 1
    let cmd = "setenv LASTJOB \\\!\\\!"
    let g:ScreenRun_first = 1
  else
    let cmd = ""
  endif

  if g:ScreenRun_path != './' && g:ScreenRun_path != '.'
    let cmd .= '; cd ' . g:ScreenRun_path
  endif

  let cmd .= '; rm -f screenlog.' . g:ScreenRun_winu
  let cmd .= '; ls'


  let g:torun = "screen -p " . g:ScreenRun_winu . " -X stuff \'" . cmd . "\'" . enter
  
  "echo "silent! !". g:torun
  execute "silent! !". g:torun


"============================================================================"
"                       Send the real command to screen                      "
"============================================================================"
  "" Start to constuct the command to run on
  let cmd = ''
  "let cmd = 'screen -X msgwait 0; screen -X log '
  let cmd .= ';' .  g:ScreenRun_comd
  "let cmd .= '; echo "Job is done\!" '
  "let cmd .= '; screen -X log ; screen -X msgwait 4'
  let g:torun = "screen -p " . g:ScreenRun_winu . " -X stuff \'" . cmd . "\'" . enter
  
  "echo "silent! !". g:torun
  execute "silent! !". g:torun

"============================================================================"
"                     Split window to monitor the output                     "
"============================================================================"
  "" Find the logfile 
  if filereadable(g:ScreenRun_path . "/screenlog" . "." . g:ScreenRun_winu)
    let s:logfile = g:ScreenRun_path . "/screenlog" . "." . g:ScreenRun_winu 
  endif

  if filereadable(g:ScreenRun_logp . "/screenlog" . "." . g:ScreenRun_winu)
    let s:logfile = g:ScreenRun_logp . "/screenlog" . "." . g:ScreenRun_winu 
  endif

  if !exists("s:logfile")
    return
  endif


    if bufwinnr(bufnr(expand(s:logfile))) != -1
      exec bufwinnr(bufnr(expand(s:logfile))) . "wincmd w" 
      setlocal autoread
      redir => s:sy
      silent! syntax list
      redir END
      echo len(s:sy)
    else
      " open the file in a split
      exec 10 . "split " . expand(s:logfile)

      if exists("g:loaded_AnsiEscPlugin") && !exists("b:AnsiEsc")
        setlocal conceallevel=3 
        AnsiEsc
        syntax match ansiConceal "" conceal cchar=3
      endif

      nnoremap <buffer> <silent> x  \|:silent exec 'resize '.( winheight('.') > 10 ? 10 : (winheight('.') + 100))<CR>
      nnoremap <buffer> <silent> q  :bwipeout % <CR>
      nnoremap <buffer> <silent> r  :checktime<CR>G

      setlocal autoread

      "setlocal buftype=nofile
      "setlocal bufhidden=hide
      "setlocal winfixheight
      "setlocal noswapfile
      "setlocal nobuflisted

    endif
    " remove boring build output
    "%s/^\[xslt\].*$/
    execute "silent! %s/]2;/[31;4mENV[m /g"
    execute "silent! %s//\r/g"
    setlocal number
    setlocal nowrap
    setlocal nomodified
    setlocal nomodifiable
    "

    autocmd CursorHold     * call s:UpdateScreenlog(s:logfile)
    autocmd CursorHoldI    * call s:UpdateScreenlog(s:logfile)
    autocmd BufEnter       * call s:UpdateScreenlog(s:logfile)
    
    " go back to the previous window
    wincmd p

    redraw!

endfunction "}}}
"
function! s:UpdateScreenlog(filename) "{{{
    if a:filename == ''
        return
    endif

    if !bufexists(a:filename)
      return
    endif

    " Make sure the taglist window is present
    let winnum = bufwinnr(a:filename)
    if winnum == -1
        return
    endif

    " Ignore all autocommands
    let old_ei = &eventignore
    set eventignore=all

    " Save the original window number
    let org_winnr = winnr()

    " Go to the taglist window
    if org_winnr != winnum
        exe winnum . 'wincmd w'
    endif

    checktime
    normal G

    " Go back to the original window
    if org_winnr != winnum
        exe org_winnr . 'wincmd w'
    endif

    " Restore the autocommands
    let &eventignore = old_ei
    return
endfunction "}}}

if match($TERM, "screen") != -1
  nmap <silent> <leader>sr :call ScreenRunFunc()<CR>
endif
