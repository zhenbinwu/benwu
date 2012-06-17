map  <buffer> <F4> :call AutoMake()<CR><CR>
map  <buffer> <F5> :call Runexe()<CR>
map  <buffer> <F6> :call Showexe()<CR>
map  <buffer> <leader>rr :w<cr>:!root -l  %<CR>
imap <buffer> <leader>rr <Esc>:w<CR>:!root -l  %<CR>
map  <buffer> <leader>dd :g/.*__func__.*__FILE__.*__LINE__.*/d<cr>:nohl<cr>

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

fun! AutoMake() "{{{
python << EOF
def Auto_Makeprg():
    import re
    import os
    import vim
    from sets import Set

    ## Define Variable
    key_map={}
    map_set=Set()
    ## Define for boost path, could be path or env variable
    BOOST_INCLUDE = ''
    BOOST_LIB = ''

    ## Define pattern for different type
    key_map['root']="T\w*"
    key_map['pthread']="pthread[\.h]."
    key_map['boost']="boost\/\w*"
    ## Additional Boost libraries needed to load from boost_getting_started
    key_map['boost_filesystem']="boost\/filesystem*"
    key_map['boost_iostreams']="boost\/iostreams*"
    #key_map['boost_graph']="boost\/graph*" No sure, haven't used it yet
    key_map['boost_mpi']="boost\/mpi*"
    key_map['boost_program_options']="boost\/program_options*"
    key_map['boost_python']="boost\/python*"
    key_map['boost_regex']="boost\/regex*"
    key_map['boost_serialization']="boost\/serialization*"
    key_map['boost_signal']="boost\/signal*"
    key_map['boost_system']="boost\/system*"
    key_map['boost_thread']="boost\/thread*"
    key_map['boost_date_time']="boost\/date_time*"


    ## Looping file till main function and detect the including file
    i = -1 
    for i in range(len(vim.current.buffer)):
        line = vim.current.buffer[i].strip()
        include=re.search(r"#include\s*[<\"]([^>\"]*)[>\"]", line)
        if include:
            for key in key_map.viewkeys():
                    if re.search(key_map[key], include.group(1)):
                        map_set.add(key)
        elif re.search(r"\s*main\s.*\(.*\)\s*", line):
            break

    if i == len(vim.current.buffer):
        vim.command('echomsg  "No Main function? That is not good!"')
        return false
    

    vim.command('w!')
    cmd="setlocal makeprg="
    cmd+="g++\ -g\ -Wall\ "

    for key in map_set:
        if key == 'pthread':
            cmd+="-lpthread\ "
        elif key == 'root':
            if os.system('which root-config >& /dev/null') != 0:
                continue
            include = os.popen('root-config --cflags').read().strip()
            include += ' '
            cmd+=include.replace(' ', '\ ')
            lib = os.popen('root-config --glibs').read().strip()
            lib += ' '
            cmd +=lib.replace(' ', '\ ')
        elif key == 'boost':
            ## BOOST header directory
            if BOOST_INCLUDE != '':
                try:
                    BOOST_INCLUDE = os.environ[BOOST_INCLUDE]
                except KeyError:
                    BOOST_INCLUDE = os.path.expanduser(BOOST_INCLUDE)

                if os.path.isdir(BOOST_INCLUDE):
                    cmd += "-I%s\ " % BOOST_INCLUDE

            ## BOOST Libs directory
            if BOOST_LIB != '':
                try:
                    BOOST_LIB = os.environ[BOOST_LIB]
                except KeyError:
                    BOOST_LIB = os.path.expanduser(BOOST_LIB)

                if os.path.isdir(BOOST_LIB):
                    cmd += "-L%s\ " % BOOST_LIB
        elif re.match('boost_*', key):
            cmd+="-l%s\ " % key
            
    
    cmd+="-o\ %:r\ %"
    vim.command(cmd.strip())

Auto_Makeprg() 
EOF
silent make
redraw!
" Open cwindow
cwindow
let tlist=getqflist() ", 'get(v:val, ''bufnr'')')
if empty(tlist)
  if !hlexists('GreenBar')
    hi GreenBar term=reverse ctermfg=white ctermbg=darkgreen guifg=white guibg=darkgreen
  endif
  echohl GreenBar
  echomsg "Compiled Successfully!"
  echohl None
endif
endfunction "}}}
