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
"set tags+=~/.vim/ftplugin/boost_tags

fun! AutoMake() "{{{
  "" Get to the original file location
  cd %:p:h
python << EOF
# File        : make.py
# Author      : Ben Wu
# Contact     : benwu@fnal.gov
# Date        : 2012 Jun 21
#
# Description : The class MakePrg is able to generate correct make statement
# for g++ for vim. It read in a C/C++ file and then find out all the included
# header files and auto all the include path and libraries needed for
# compilation. It uses alternative for header files search.

import re
import os
import vim
from sets import Set

### Define the C++ compiler to be used
CXX           = 'g++'
### Define the C++ flags
CXXFLAGS      = '-g -Wall'
## Define for boost path, could be path or env variable
BOOST_INCLUDE = '~/BenSys/boost/'
BOOST_LIB = '~/BenSys/boost/stage/lib/'
## Additional file path beside from g:alternateSearchPath
FILE_PATH = ''


class MakePrg:
    def __init__(self):
        self.map_set = Set()
        self.key_map = {}
        ## Get the available path
        self.path_list = ['.']
        ## Get open file list
        ## Unfortunately I need this to prevent mulitple load
        self.file_list = []
        self.is_main = False
        self.local_inc = ''
        self.local_src = ''
        self.dict = vim.eval("g:alternateExtensionsDict")
        self.__init_key__()
        self.__init_path__()

    def __init_key__(self):
        ## Define pattern for different type
        self.key_map['root'] = "T\w*"
        self.key_map['pthread'] = "pthread[\.h]."
        self.key_map['boost'] = "boost\/\w*"
        ## Additional Boost libraries needed to load
        self.key_map['boost_date_time'] = "boost\/date_time*"
        self.key_map['boost_chrono'] = "boost\/chrono*"

        self.key_map['boost_exception'] = "boost\/exception*"
        self.key_map['boost_filesystem'] = "boost\/filesystem*"
        self.key_map['boost_locale'] = "boost\/locale*"
        self.key_map['boost_iostreams'] = "boost\/iostreams*"
        self.key_map['boost_mpi'] = "boost\/mpi*"
        self.key_map['boost_program_options'] = "boost\/program_options*"
        self.key_map['boost_python'] = "boost\/python*"
        self.key_map['boost_regex'] = "boost\/regex*"
        self.key_map['boost_serialization'] = "boost\/serialization*"
        self.key_map['boost_signal'] = "boost\/signal*"
        ## Chrono need system
        self.key_map['boost_system'] = "boost\/(system|chrono)\w*"
        self.key_map['boost_thread'] = "boost\/thread*"
        self.key_map['boost_unit_test_framework'] = "boost\/test\/unit_test\.hpp"
        #key_map['boost_graph'] = "boost\/graph*" No sure, haven't used it yet
        ## Don't understand math_tr1, may just use boost::math
        # self.key_map['boost_math_tr1'] = "boost\/math\/tr1\.hpp"
        # self.key_map['boost_math_tr1f'] = "boost\/math\/tr1\.hpp"
        # self.key_map['boost_math_tr1l'] = "boost\/math\/tr1\.hpp"

    def __init_path__(self):
        global FILE_PATH
        ## Get the defined path from locate define and alternate.vim
        alternateSearchPath = vim.eval("g:alternateSearchPath")
        #alternateSearchPath = 'sfr:../source,sfr:../src,sfr:../include, \ sfr:../inc,sfr:../'
        path_org = alternateSearchPath.replace('sfr:', '').split(',')
        if len(FILE_PATH) != 0:
            path_org += FILE_PATH.split(',')

        for _path in path_org:
            path = _path.strip()
            ## Skip the unavailable path
            if os.path.isdir(path):
                self.path_list.append(path)

    def Makeprg(self, buffer):
        ## Looping file till main function and detect the including file
        i = -1
        for i in range(len(buffer)):
            line = buffer[i].strip()
            include = re.search(r"#include\s*[<\"]([^>\"]*)[>\"]", line)
            if include:
                for key in self.key_map.viewkeys():
                    if re.search(self.key_map[key], include.group(1)):
                        self.map_set.add(key)
                if re.search(r"#include\s*\"([^>\"]|boost\/)*\"", line) != \
                None and include.group(1).find("boost/") == -1:
                    self.AddLocal(include.group(1))
            elif re.search(r"\s*main\s.*\(.*\)\s*", line):
                self.is_main = True
                break

    def AddLocal(self, include):
        ## split into filename and extension
        filename = include[:include.rfind('.')]
        extension = include[include.rfind('.')+1:]

        found_header = False  # Whether we found header
        ## Include all the file with filename in available path
        for path in self.path_list:
            ## Find included file
            if os.path.isfile(path + "/" + include) \
               and self.Check_FileList(include):
                cmd_local = '%s' % (path + "/" + include)
                if not re.match("^\.[/]*$", path):
                    self.local_inc += "-I%s\ " % path
                found_header = True
                file = open(cmd_local, 'r')
                self.Makeprg(file.readlines())
                file.close()
                break

        if found_header:
            ## Start to find the local source
            found_src = False  # Whether we found another source file
            filename = filename[filename.rfind('/')+1:]
            for path in self.path_list:
                for alter in self.dict[extension].split(','):
                    if os.path.isfile(path + "/" + filename + '.' + alter) \
                    and self.Check_FileList(filename + '.' + alter):
                        found_src = True
                        cmd_local = '%s' % (path + "/" + filename + '.' + alter)
                        self.local_src += '\ %s' % cmd_local
                        file = open(cmd_local, 'r')
                        self.Makeprg(file.readlines())
                        file.close()
                        break

                ## If one alternative found, then should be enough
                if found_src:
                    continue

                ## In case not, lets reverse the dict from alternate.vim
                for key, var in self.dict.iteritems():
                    if var.split(',').count(extension) != 0:
                        if os.path.isfile(path + "/" + filename + '.' + key) \
                        and self.Check_FileList(filename + '.' + key):
                            found_src = True
                            cmd_local = '%s' % (path + "/" + filename + '.' + key)
                            self.local_src += '\ %s' % cmd_local
                            file = open(cmd_local, 'r')
                            self.Makeprg(file.readlines())
                            file.close()
                            break

    def Check_FileList(self, file):
        if file in self.file_list:
            return False
        else:
            self.file_list.append(file)
            return True

    def Auto_Makeprg(self, buffer):
        global CXX
        global CXXFLAGS
        global BOOST_INCLUDE
        global BOOST_LIB

        self.file_list.append(vim.current.buffer.name.split('/')[-1])
        self.Makeprg(buffer)

        vim.command('w!')
        cmd = "setlocal makeprg="

        ### Set the MakePrg
        compiler = CXX.strip()+' '+CXXFLAGS.strip()+' '
        cmd += compiler.replace(' ', '\ ')
        cmd += self.local_inc

        for key in self.map_set:
            if key == 'pthread':
                cmd += "-lpthread\ "
            elif key == 'root':
                if os.system('which root-config >& /dev/null') != 0:
                    continue
                include = os.popen('root-config --cflags').read().strip()
                include += ' '
                cmd += include.replace(' ', '\ ')
                if self.is_main:
                    lib = os.popen('root-config --glibs').read().strip()
                    lib += ' '
                    cmd += lib.replace(' ', '\ ')
            elif key == 'boost':
                ## Env BOOST_ROOT point to the directory
                try:
                    BOOST_ROOT = os.environ["BOOST_ROOT"]
                    if os.path.isdir(BOOST_ROOT):
                        cmd += "-I%s\ " % BOOST_ROOT
                    if os.path.isdir(BOOST_ROOT + "/stage/lib") \
                      and self.is_main:
                        cmd += "-L%s\ " % (BOOST_ROOT + "/stage/lib")
                except KeyError:
                    ## User BOOST header directory
                    if BOOST_INCLUDE != '':
                        try:
                            BOOST_INCLUDE = os.environ[BOOST_INCLUDE]
                        except KeyError:
                            BOOST_INCLUDE = os.path.expanduser(BOOST_INCLUDE)
                        if os.path.isdir(BOOST_INCLUDE):
                            cmd += "-I%s\ " % BOOST_INCLUDE

                    ## User BOOST Libs directory
                    if BOOST_LIB != '' and self.is_main:
                        try:
                            BOOST_LIB = os.environ[BOOST_LIB]
                        except KeyError:
                            BOOST_LIB = os.path.expanduser(BOOST_LIB)
                        if os.path.isdir(BOOST_LIB):
                            cmd += "-L%s\ " % BOOST_LIB

            elif re.match('boost_*', key) and self.is_main:
                cmd += "-l%s\ " % key

        if self.is_main:
            cmd += "-o\ %:r\ %"
            cmd += self.local_src
        else:
            cmd += "-c\ %"

        try:
            vim.command(cmd.strip())
        except vim.error:
            print "Error from Vim"

todo = MakePrg()
todo.Auto_Makeprg(vim.current.buffer)
EOF
"5sleep
cclose
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

cd -
endfunction "}}}
