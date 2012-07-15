function! textobj#pair#select_underscore_a()  "{{{
  normal F_

  let end_pos = getpos('.')

  normal f_

  let start_pos = getpos('.')
  return ['v', start_pos, end_pos]
endfunction "}}}

function! textobj#pair#select_underscore_i()  "{{{
"function! s:select_i()

  normal T_

  let end_pos = getpos('.')

  normal t_

  let start_pos = getpos('.')

  return ['v', start_pos, end_pos]
endfunction "}}}

function! textobj#pair#select_dollar_a()  "{{{
  normal F$

  let end_pos = getpos('.')

  normal f$

  let start_pos = getpos('.')
  return ['v', start_pos, end_pos]
endfunction "}}}

function! textobj#pair#select_dollar_i()  "{{{

  normal T$

  let end_pos = getpos('.')

  normal t$

  let start_pos = getpos('.')

  return ['v', start_pos, end_pos]
endfunction "}}}

function! textobj#pair#select_pound_a()  "{{{
  normal F#

  let end_pos = getpos('.')

  normal f#

  let start_pos = getpos('.')
  return ['v', start_pos, end_pos]
endfunction "}}}

function! textobj#pair#select_pound_i()  "{{{

  normal T#

  let end_pos = getpos('.')

  normal t#

  let start_pos = getpos('.')

  return ['v', start_pos, end_pos]
endfunction "}}}
