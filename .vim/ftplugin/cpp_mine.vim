if( match(hostname(), 'nbay') >=0 )
  map <F4> <Esc>:w!<CR>:set makeprg=g++\ -g\ -Wall\ -I/cdf/code/cdfsoft/products/root/v5_26_00-GCC_3_4_6/Linux+2.6/include\ -I/mnt/autofs/misc/nbay05.a/benwu/BenSys/include\ -o\ %:r.exe\ % <CR>:make<CR>:cw<CR><CR>
elseif( match(hostname(), 'ThinkPad') >=0 )
  map <F4> <Esc>:w!<CR>:set makeprg=g++\ -g\ -Wall\ -I/home/benwu/BenSys/include/root\ -I/home/benwu/BenSys/include\ -o\ %:r.exe\ % <CR>:make<CR>:cw<CR><CR>
else
  map <F4> <Esc>:w!<CR>:set makeprg=g++\ -g\ -Wall\ -o\ %:r\ % <CR>:make<CR>:cw<CR><CR>
endif


map <F5> :call Runexe()<CR>
map <F6> :call Showexe()<CR>
map <leader>rr :w<cr>:!root -l  %<CR>
imap <leader>rr <Esc>:w<CR>:!root -l  %<CR>
map <leader>dd :g/.*__func__.*__FILE__.*__LINE__.*/d<cr>:nohl<cr>

fun! Runexe() "{{{
  let Exe  = "./".expand("%:r").".exe"
  let Run  = "./".expand("%:r")
  if executable(Exe) && !executable(Run)
    exe		"!".Exe
  endif
  if !executable(Exe) && executable(Run)
    exe		"!".Run
  endif

  if executable(Exe) && executable(Run)
    if getftime(Exe) >= getftime(Run) 
      exe		"!".Exe
    else
      exe		"!".Run
    endif
  endif
endfunction "}}}

fun! Showexe() "{{{
  let Exe  = "./".expand("%:r").".exe"
  let Run  = "./".expand("%:r")
  if executable(Exe) && !executable(Run)
    call inputsave()
    let name = input(':!'.Exe.' ')
    call inputrestore()
    let ExeSrc = ":!".Exe." ".name
    exe         ExeSrc
  endif
  if !executable(Exe) && executable(Run)
    call inputsave()
    let name = input(':!'.Run.' ')
    call inputrestore()
    let RunSrc = ":!".Run." ".name
    exe         RunSrc
  endif

  if executable(Exe) && executable(Run)
    if getftime(Exe) >= getftime(Run) 
      call inputsave()
      let name = input(':!'.Exe.' ')
      call inputrestore()
      let ExeSrc = ":!".Exe." ".name
      exe         ExeSrc
    else
      call inputsave()
      let name = input(':!'.Run.' ')
      call inputrestore()
      let RunSrc = ":!".Run." ".name
      exe         RunSrc
    endif
  endif
endfunction "}}}

set tags+=~/.vim/ftplugin/cpp_tags
set tags+=~/.vim/ftplugin/boost_tags
