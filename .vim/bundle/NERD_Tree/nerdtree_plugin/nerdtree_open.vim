if exists("g:loaded_nerdtree_plugin_open")
    finish
endif
let g:loaded_nerdtree_plugin_open = 1


function! s:callback_name()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_') . 'callback'
endfunction

function! s:callback()
    if exists('*vimproc#open')
        call vimproc#open(g:NERDTreeFileNode.GetSelected().path.str())
    else
        let path = g:NERDTreeFileNode.GetSelected().path.str({'escape': 1})

        if !exists("g:nerdtree_plugin_open_cmd")
            echoerr "please set 'g:nerdtree_open_cmd'  to 'open','gnome-open' or 'xdg-open'"
            echoerr "or install vimproc from 'https://github.com/Shougo/vimproc'"
            return
        endif
        let cmd = g:nerdtree_open_cmd . " " . path
        call system(cmd)
    endif
endfunction

call NERDTreeAddKeyMap({
      \ 'callback': s:callback_name(),
      \ 'quickhelpText': 'close nerd tree if open',
      \ 'key': 'E',
      \ })

call NERDTreeAddMenuItem({
            \ 'text': '(o)open with system command',
            \ 'shortcut': 'o',
            \ 'callback': s:callback_name()})
