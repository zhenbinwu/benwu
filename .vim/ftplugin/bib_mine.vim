let g:Bib_misc_options = "althy"

autocmd BufLeave *.bib call WirteFile()
fun! WirteFile() "{{{
  silent! write!
endfunction "}}}
