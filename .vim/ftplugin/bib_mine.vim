let g:Bib_misc_options = "althy"
let g:Bib_note_options = "althy"

set paste
autocmd BufLeave *.bib call WirteFile()
fun! WirteFile() "{{{
  silent! write!
endfunction "}}}
