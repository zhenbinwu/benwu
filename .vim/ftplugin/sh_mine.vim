map <F5> :call Runexe()<CR>
map <F6> :call Showexe()<CR>

fun! Runexe() "{{{
  exe "w"
  let Sh   = "./".expand("%")
  if executable(Sh)
    exe		"!".Sh
  endif
endfunction "}}}

fun! Showexe() "{{{
  silent exe "w"
  let Sh   = "./".expand("%")
  if executable(Sh)
    call inputsave()
    let name = input(':!'.Sh.' ')
    call inputrestore()
    let ShSrc = ":!".Sh." ".name
    exe         ShSrc
  endif
endfunction "}}}

