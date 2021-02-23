if executable('vivado_hls')
  if search("^open_project", "nw")!=0
    map  <buffer> <F5> :!vivado_hls -f %<CR>
  endif
endif

