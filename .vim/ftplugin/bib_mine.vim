let g:Bib_misc_options = "althy"
set foldmethod=syntax

autocmd BufLeave *.bib call WirteFile()
fun! WirteFile() "{{{
  silent! write!
endfunction "}}}
