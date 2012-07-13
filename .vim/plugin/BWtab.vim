"" File Description {{{
" =============================================================================
" This script does two things. One for setting the tab number and the number
" of the windows in the tab label, which make it easier for gt/gT.
" Another thing is it make <C-@> for switching between two tabs like <C-^> for
" buffers.
"                                                  by Ben Wu
"                                                     benwu@fnal.gov
" Usage : Load this vim script
"
" =============================================================================
" }}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display tab number in tabline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! MyTabLine()
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
endfunction

set tabline=%!MyTabLine()

set guitablabel=%N\|%n\ %M%t
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map for switching between the last two tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
au TabLeave * :let g:last_tab=tabpagenr()
function! <sid>LastTab()
  if !exists("g:last_tab")
    return
  endif
  exe "tabn" g:last_tab
endfu

nmap <silent> <leader>tt :call <sid>LastTab()<CR>
