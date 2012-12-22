function! Powerline#Functions#project#GetProject() " {{{
  let save_cursor = getpos(".")

  let previous_cursor = getpos(".")
  let current_cursor = getpos("$")
  let pos = ''
  while previous_cursor != current_cursor
    let previous_cursor = getpos(".")
    normal [{
    let current_cursor = getpos(".")
    let pos = substitute(getline("."), '\v^[^A-Za-z0-9_]*([^=]+)=.*', '\1', '') . ":" . pos
  endwhile

  call setpos('.', save_cursor)
  let g:project_powerline=join(split(pos, ':', 1)[1:-2], ":")
  return g:project_powerline
endfunction "}}}
