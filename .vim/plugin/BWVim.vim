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

fun! MapMake(output) "{{{
  if exists("g:syntastic_enable") 
    let syntastic_temp = g:syntastic_enable
    if g:syntastic_enable == 1
      let g:syntastic_enable = 0
    endif
  endif
  w
  if a:output == 0
    silent make
  elseif a:output == 1
    silent make %:r
  endif
  cwindow
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

map <F7> <Esc>:call QLstep(-1)<CR>
map <F8> <Esc>:call QLstep(1)<CR>
imap <F7> <Esc>:call QLstep(-1)<CR>
imap <F8> <Esc>:call QLstep(1)<CR>

"" Indicate weather the compiling is completed successfully!
function! QfMakeConv()
  let qflist_end = getqflist()[-1]['text']
  for igndir in split(g:qflist_done, ", ")
    if match(qflist_end, " ".igndir."$") != -1
      let g:qflist_result = "Success"
      break
    endif
  endfor
endfunction

au QuickFixCmdPre  make let g:qflist_result = ''
au QuickFixCmdPost make call QfMakeConv()

function! HighlightRepeats() range"{{{
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
endfunction"}}}

command! -range=% HighlightRepeats <line1>,<line2>call HighlightRepeats()

function! s:OnlineDoc(word)"{{{
  let s:wordUnderCursor = a:word
  let s:ask = "What to google: " 
  let s:string = input(s:ask, s:wordUnderCursor . " ")
  let s:string = substitute(s:string, " ", "+", "g")
  let s:string = substitute(s:string, "+*$", "", "g")

  call s:OnlineWord(s:string)
endfunction"}}}
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
