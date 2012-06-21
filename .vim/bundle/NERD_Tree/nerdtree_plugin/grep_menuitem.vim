if exists("g:loaded_nerdtree_grep_menuitem")
    finish
endif
let g:loaded_nerdtree_grep_menuitem = 1

if !executable("grep")
    finish
endif

call NERDTreeAddMenuItem({
    \ 'text': '(g)rep directory',
    \ 'shortcut': 'g',
    \ 'callback': 'NERDTreeGrepMenuItem' })

function! NERDTreeGrepMenuItem()
    let n = g:NERDTreeDirNode.GetSelected()

    let pattern = input("Search Pattern: ")
    if pattern == ''
        return
    endif

    "use the previous window to jump to the first search result
    let s:main = GetCurrentMainWindow()
    exe s:main . 'wincmd w'
    echo  n.path.str()
    exec 'silent grep --exclude="*.pdf" -Irw "' . pattern . '" ' . n.path.str()

    let hits = len(getqflist())
    if hits == 0
        redraw!
        echo "No hits"
    elseif hits > 1
        copen
        exe s:main . 'wincmd w'
        redraw!
    endif

endfunction

fun! GetCurrentMainWindow() "{{{
    let bufs = tabpagebuflist(tabpagenr())
    let w = 0
    let main = 0
    while w < tabpagewinnr(tabpagenr(), '$')
      if bufname(bufs[w]) == "[Buf List]"  ||  
      \  bufname(bufs[w]) == "__Tag_List__" ||
      \  bufname(bufs[w]) == "[NERDTree]" || 
      \  bufname(bufs[w]) == "__Tagbar__" ||
      \  bufname(bufs[w]) == "__Gundo__" ||
      \  bufname(bufs[w]) == "__Gundo_Preview__" 
        let w += 1
        continue
      endif

      let main = w
      let w += 1
    endwhile
  unlet w bufs 
  return main+1
  
endfunction "}}}
