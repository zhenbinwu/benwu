if exists("g:loaded_nerdtree_path_menuitem")
    finish
endif
let g:loaded_nerdtree_path_menuitem = 1

function! s:callback_name()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_') . 'callback'
endfunction

function! s:callback()
    let n = g:NERDTreeFileNode.GetSelected()
    if n != {}
        call setreg('"', n.path.str())
    endif
endfunction

call NERDTreeAddKeyMap({
      \ 'callback': s:callback_name(),
      \ 'quickhelpText': 'close nerd tree if open',
      \ 'key': 'E',
      \ })

call NERDTreeAddMenuItem({
            \ 'text': '(p)copy the full path of current node ',
            \ 'shortcut': 'p',
            \ 'callback': s:callback_name()})
