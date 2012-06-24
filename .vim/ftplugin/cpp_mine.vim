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
  cclose
  update
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

### Define to compile the main in two steps
MAKEMAIN = True
### Define the C++ compiler to be used
CXX           = 'g++'
### Define the C++ flags
CXXFLAGS      = '-g -Wall'
### Define the C++ flags
LDFLAGS      = '-g -O -Wall -fPIC'

## Additional file path beside from g:alternateSearchPath
FILE_PATH = ''
## Object Path to store object, will check three levels for the path
OBJ_PATH = 'obj,object'
## Define for boost path, could be path or env variable
BOOST_INCLUDE = '~/BenSys/boost/'
BOOST_LIB = '~/BenSys/boost/stage/lib/'


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
        self.to_link = False
        self.local_inc = Set()
        self.local_src = ''
        self.dict = vim.eval("g:alternateExtensionsDict")
        self.__init_key__()
        self.__init_path__()
        ## class for timestamp
        self.time = TimeStamp()

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
            elif re.search(r"\s*main\s*\(.*\)\s*\{?", line):
                self.is_main = True
                break

    def AddLocal(self, include):
        ## split into filename and extension
        filename = include[include.rfind('/')+1:include.rfind('.')]
        extension = include[include.rfind('.')+1:]

        found_header = False  # Whether we found header
        ## Include all the file with filename in available path
        for path in self.path_list:
            ## Find included file
            if os.path.isfile(path + "/" + include) \
               and self.Check_FileList(include):
                cmd_local = '%s' % (path + "/" + include)
                self.time.add(filename, cmd_local)
                if not re.match("^\.[/]*$", path):
                    self.local_inc.add("-I%s\ " % path)
                found_header = True
                file = open(cmd_local, 'r')
                self.Makeprg(file.readlines())
                file.close()
                break

        if found_header:
            ## Start to find the local source
            found_src = False  # Whether we found another source file
            for path in self.path_list:
                for alter in self.dict[extension].split(','):
                    if os.path.isfile(path + "/" + filename + '.' + alter) \
                    and self.Check_FileList(filename + '.' + alter):
                        found_src = True
                        cmd_local = '%s' % (path + "/" + filename + '.' + alter)
                        self.time.add(filename, cmd_local)
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
                            self.time.add(filename, cmd_local)
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
        global LDFLAGS
        global BOOST_INCLUDE
        global BOOST_LIB

        self.file_list.append(vim.current.buffer.name.split('/')[-1])
        self.time.addMain(vim.current.buffer.name.split('/')[-1])
        self.Makeprg(buffer)

        if MAKEMAIN and self.is_main:
            self.to_link = self.time.check_link(self.local_src)
        if self.is_main and not MAKEMAIN:
            self.to_link = True;
         
        cmd = "setlocal makeprg="

        compiler = CXX.strip()+' '
        if not MAKEMAIN:
            flags = Set()
            [flags.add(x) for x in CXXFLAGS.split(' ')]
            [flags.add(x) for x in LDFLAGS.split(' ')]
            compiler += ' '.join(flags)
            compiler += ' '
        else:
            if self.to_link:
                return False ## Link in Auto_Linkprg
            else:
                compiler += CXXFLAGS.strip()+' '

        cmd += compiler.replace(' ', '\ ')
        cmd += ''.join(self.local_inc)

        for key in self.map_set:
            if key == 'pthread' and self.to_link:
                cmd += "-lpthread\ "
            elif key == 'root':
                if os.system('which root-config >& /dev/null') != 0:
                    continue
                include = os.popen('root-config --cflags').read().strip()
                include += ' '
                cmd += include.replace(' ', '\ ')
                if self.to_link:
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
                       and self.to_link:
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
                    if BOOST_LIB != '' and self.to_link:
                        try:
                            BOOST_LIB = os.environ[BOOST_LIB]
                        except KeyError:
                            BOOST_LIB = os.path.expanduser(BOOST_LIB)
                        if os.path.isdir(BOOST_LIB):
                            cmd += "-L%s\ " % BOOST_LIB

            elif re.match('boost_*', key) and self.to_link:
                cmd += "-l%s\ " % key

        ## single main file
        if self.is_main and len(self.local_src) == 0:
            cmd += "-o\ %:r\ %"
        ## need extra source, two methods 
        elif self.is_main and MAKEMAIN:   
            cmd += self.time.check_main(self.local_src)
        elif self.is_main and not MAKEMAIN:
            cmd += "-o\ %:r\ %"
            cmd += self.local_src
        else:
            cmd += "-c\ %"

        try:
            vim.command(cmd.strip())
        except vim.error:
            print "Error from Vim"
        return True

    def Auto_Linkprg(self, file):
        global CXX
        global CXXFLAGS
        global LDFLAGS
        global BOOST_INCLUDE
        global BOOST_LIB
        global MAKEMAIN

        self.time.addMain(vim.current.buffer.name.split('/')[-1])
        self.to_link = self.time.check_link(self.local_src)
        if not MAKEMAIN or not self.to_link:
            return None

        cmd = "setlocal makeprg="

        compiler = CXX.strip()+' '
        compiler += LDFLAGS.strip()+' '

        cmd += compiler.replace(' ', '\ ')
        cmd += ''.join(self.local_inc)

        for key in self.map_set:
            if key == 'pthread' and self.to_link:
                cmd += "-lpthread\ "
            elif key == 'root':
                if os.system('which root-config >& /dev/null') != 0:
                    continue
                include = os.popen('root-config --cflags').read().strip()
                include += ' '
                cmd += include.replace(' ', '\ ')
                if self.to_link:
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
                       and self.to_link:
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
                    if BOOST_LIB != '' and self.to_link:
                        try:
                            BOOST_LIB = os.environ[BOOST_LIB]
                        except KeyError:
                            BOOST_LIB = os.path.expanduser(BOOST_LIB)
                        if os.path.isdir(BOOST_LIB):
                            cmd += "-L%s\ " % BOOST_LIB

            elif re.match('boost_*', key) and self.to_link:
                cmd += "-l%s\ " % key

        if self.is_main:
            cmd += self.time.get_objlist()
        else:
            cmd += "-c\ %"

        try:
            vim.command(cmd.strip())
        except vim.error:
            print "Error from Vim"
            


class TimeStamp:
    def __init__(self):
        self.file={}
        self.object=ObjFile()
        self.needmain = True
        self.new_local = ''

    def addMain(self, main):
        filename = main[:main.rfind('.')]
        self.add(filename, "./"+main)
        self.needmain = self.NeedCom(filename)

    def add(self,filename, path):
        if not filename in self.file.keys():
            self.file[filename]={}
        extension = path[path.rfind('.')+1:]
        timestamp = os.path.getmtime(path)
        self.file[filename][extension]=timestamp

    def _print(self):
        for key, val in self.file.items():
            print "=========  %s :" % key
            for key2, val2 in val.items():
                print "        %s = %s " % (key+"."+key2, val2)
           
    def NeedCom(self, filename):
        if not filename in self.file.viewkeys():
            print "This should not happed!!"
            return False

        ## Now add the ojb files 
        if self.object.checktime(filename) != None:
            self.file[filename]['o']=self.object.checktime(filename) 

        if not 'o' in self.file[filename]:
            ## have both src and header, but no object
            if len(self.file[filename]) == 2:
                return True
            for key in self.file[filename].iterkeys():
                if key.find('h') != -1 or key.find('H') != -1:
                    ## Only has header
                    return False
            return True

        obtime = self.file[filename]['o']
        needcom = False;
        for var in self.file[filename].itervalues():
            if var > obtime:
                needcom = True;
        return needcom

    def check_local(self, local_src):
        for _src in local_src.split('\\'):
            if _src == '':
                continue
            src = _src.strip()
            if self.NeedCom(src[src.rfind('/')+1:src.rfind('.')]):
                self.new_local += '\ %s' % src

    def check_link(self, local_src):
        self.check_local(local_src)
        if len(self.new_local) != 0 or self.needmain :
            return False
        else:
            return True

    def check_main(self, local_src):
        cmd = "-c"
        if self.needmain:
            cmd += "\ %"
        if len(self.new_local) != 0 :
            cmd += self.new_local
        return cmd

    def get_objlist(self):
        objlist=[]
        for filename in self.file.iterkeys():
            if filename in self.object.path_map.viewkeys():
                objlist.append(self.object.path_map[filename])
        cmd = "-o\ %:r\ "
        cmd += "\ ".join(objlist)
        return cmd

class ObjFile():
    def __init__(self):
        self.ojpath=self.__check_path__()
        self.path_map={}
       
    def __check_path__(self):
        global OBJ_PATH
        allpath = []

        for path in OBJ_PATH.split(','):
            if os.path.isdir("../"+path):
                allpath.append("../"+path)
            if os.path.isdir("./"+path):
                allpath.append("./"+path)
            for subdir in os.listdir("."):
                if os.path.isdir(subdir+path):
                    allpath.append(subdir+path)

        if len(allpath) > 1:
            print "Error!! "
            return None
        elif len(allpath) == 0:
            return "./"

        else:
            return allpath[0]

    def checktime(self, file):
        obj = self.ojpath+"/"+file+".o"
        if os.path.isfile(obj):
            self.path_map[file]=obj
            return os.path.getmtime(obj)
        return None

def CleanObj():
    ### After run , move all the locale obj files to obj dir
    ojpath =ObjFile().ojpath
    for _objfile in os.popen("ls *.o").readlines():
        objfile = _objfile.strip()
        os.system("mv "+objfile+ " " + ojpath)


todo = MakePrg()
if todo.Auto_Makeprg(vim.current.buffer):
    #print "====================== Compiling"
    #vim.command('echo &makeprg')
    #vim.command('5sleep')
    vim.command('silent make')
    CleanObj()
    vim.command('redraw!')
if MAKEMAIN and todo.is_main and \
    len(todo.local_src) != 0 and \
    len(vim.eval("getqflist()")) == 0:
    todo.Auto_Linkprg(vim.current.buffer)
    #print "====================== Linking "
    #vim.command('echo &makeprg')
    #vim.command('5sleep')
    vim.command('silent make')
EOF
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
