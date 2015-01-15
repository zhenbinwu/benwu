if exists("g:loaded_nerdtree_root_menuitem")
    finish
endif
let g:loaded_nerdtree_root_menuitem = 1

if !executable("root")
    finish
endif

function! s:callback_name()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_') . 'callback'
endfunction

function! s:callback()
    if exists('*vimproc#open')
        call vimproc#open(g:NERDTreeFileNode.GetSelected().path.str())
    else
        let path = g:NERDTreeFileNode.GetSelected().path.str({'escape': 1})
        let g:temp = path

        if path !~ '\.root'
          echo "Not a root file!"
          return
        endif

        if !exists("g:nerdtree_open_cmd")
            echoerr "please set 'g:nerdtree_open_cmd'  to 'open','gnome-open' or 'xdg-open'"
            echoerr "or install vimproc from 'https://github.com/Shougo/vimproc'"
            return
        endif

        let cmd = "root -l ".path. " ". expand("$HOME/.vim/bundle/NERD_Tree/nerdtree_plugin/ls.C")
        call conque_term#open(cmd, ['botright split'])
    endif
endfunction

call NERDTreeAddKeyMap({
      \ 'callback': s:callback_name(),
      \ 'quickhelpText': 'close nerd tree if open',
      \ 'key': 'E',
      \ })

call NERDTreeAddMenuItem({
            \ 'text': '(r)open with root',
            \ 'shortcut': 'r',
            \ 'callback': s:callback_name()})
