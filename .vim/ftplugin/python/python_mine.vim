function! SetColorColumn()
    let col_num = virtcol(".")
    let cc_list = split(&cc, ',')
    if count(cc_list, string(col_num)) <= 0
        execute "set cc+=".col_num
    else
        execute "set cc-=".col_num
    endif
endfunction
map ,ch :call SetColorColumn()<CR>

fun! AutoRun() "{{{
  update
  let save_cursor = getpos(".")
  let runCMSRun = 0
  if exists("$CMSSW_BASE") && match(expand("%:p:h"), expand("$CMSSW_BASE")) != -1 
    normal gg
    let beginline = search('import FWCore\.ParameterSet\.Config as cms', 'W')
    let endline = search('cms.Path(', 'W')
    if beginline != 0 && endline != 0
      let runCMSRun = 1
    endif
  endif

  if runCMSRun == 1
    execute "!cmsRun %"
  else
    execute "!python %"
  endif

  call setpos('.', save_cursor)
  return
endfunction "}}}

map <buffer> <F5> <Esc>:call AutoRun()<CR>
imap <buffer> <F5> <Esc>:call AutoRun()<CR>
