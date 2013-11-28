map <buffer> <F5> :w<cr>:!python %<cr>
imap <buffer> <F5> <Esc>:w<cr>:!python %<cr>

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
