fun! AutoMake() "{{{

  if g:AutoMake == "compile init"
python << EOF
def Main():
    if todo.Auto_Makeprg(vim.current.buffer):
        Message = ColorEcho("Compile", vim.eval("&makeprg"))
        vim.command(Message)
        vim.command("let g:AutoMake = 'compile fuck'" )
        if FORTUNE :
            try: 
                MakeFortune()
            except KeyboardInterrupt:   
                pass
        else:
            try:
                vim.command('silent make')
                CleanObj()
                vim.command("let g:AutoMake = 'compile done'" )
            except KeyboardInterrupt:   
                pass
        vim.command('redraw!')
        if len(vim.eval("getqflist()")) == 0:
            vim.command("hi GreenBar term=reverse ctermfg=white ctermbg=darkgreen guifg=white guibg=darkgreen")
            vim.command("echohl GreenBar")
            vim.command("echomsg \"Compiled Successfully!\"")
            vim.command("echohl None")
    if MAKEMAIN and todo.is_main and \
        len(todo.local_src) != 0 and \
        len(vim.eval("getqflist()")) == 0:
        todo.Auto_Linkprg(vim.current.buffer)
        Message = ColorEcho("Link", vim.eval("&makeprg"))
        vim.command(Message)
        vim.command('silent make')
        vim.command('redraw!')
        if len(vim.eval("getqflist()")) == 0:
            vim.command("hi GreenBar term=reverse ctermfg=white ctermbg=darkgreen guifg=white guibg=darkgreen")
            vim.command("echohl GreenBar")
            vim.command("echomsg \"Linked Successfully!\"")
            vim.command("echohl None")

if __name__ == "__main__":
    try:
        Main()
        vim.command(" let g:AutoMake = 'Done'" )
    except: 
        pass
EOF
  endif

  if g:AutoMake == "Compile done"
python << EOF
if MAKEMAIN and todo.is_main and \
    len(todo.local_src) != 0 and \
    len(vim.eval("getqflist()")) == 0:
    todo.Auto_Linkprg(vim.current.buffer)
    Message = ColorEcho("Link", vim.eval("&makeprg"))
    vim.command(Message)
    vim.command('silent make')
    vim.command('redraw!')
    if len(vim.eval("getqflist()")) == 0:
        vim.command("hi GreenBar term=reverse ctermfg=white ctermbg=darkgreen guifg=white guibg=darkgreen")
        vim.command("echohl GreenBar")
        vim.command("echomsg \"Linked Successfully!\"")
        vim.command("echohl None")

EOF
  endif


endfunction "}}}

fun! MapAutoMake() "{{{
  silent !rm obj/*
  silent !rm ./test2

  "" Start fresh
  cclose
  call setqflist([])
  update

  "" What is this for?
  cd %:p:h

  "" Use this string to identify the steps
  let g:AutoMake = ""

"Wrapper of python {{{
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
### Whether to read fortune while compiling
FORTUNE = True
### Define the C++ compiler to be used
CXX           = 'g++'
### Define the C++ flags
CXXFLAGS      = '-g -Wall -fpic'
### Define the C++ flags
LDFLAGS      = '-g -O -Wall'

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
        self.key_map['pthread'] = "pthread[\.h].|boost\/flyweight\.hpp"
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
        self.key_map['boost_signals'] = "boost\/signals*"
        self.key_map['boost_wave'] = "boost\/wave*"
        ## Chrono need system
        self.key_map['boost_system'] = "boost\/(system|chrono|timer|asio)\w*"
        self.key_map['boost_thread'] = "boost\/thread*"
        self.key_map['boost_timer'] = "boost\/timer*"
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
        global MAKEMAIN
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
        if self.is_main and len(self.local_src) == 0:
            self.to_link = True;
         
        cmd = "setlocal makeprg="

        compiler = CXX.strip()+' '
        if not MAKEMAIN or len(self.local_src) == 0 and self.is_main:
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
        libs = ''

        for key in self.map_set:
            if key == 'pthread' and self.to_link:
                libs += "-lpthread\ "
            elif key == 'root':
                if os.system('which root-config >& /dev/null') != 0:
                    continue
                include = os.popen('root-config --cflags').read().strip()
                include += ' '
                cmd += include.replace(' ', '\ ')
                if self.to_link:
                    lib = os.popen('root-config --glibs').read().strip()
                    lib += ' '
                    libs += lib.replace(' ', '\ ')
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
                libs += "-l%s\ " % key


        if len(libs) != 0:
            libs = "\ "+libs[:libs.rfind("\ ")]
        ## single main file
        if self.is_main and len(self.local_src) == 0:
            cmd += "-o\ %:r\ %"
            cmd += libs
        ## need extra source, two methods 
        elif self.is_main and MAKEMAIN:   
            cmd += self.time.check_main(self.local_src)
        elif self.is_main and not MAKEMAIN:
            cmd += "-o\ %:r\ %"
            cmd += self.local_src
            cmd += libs
        else:
            cmd += "-c\ %"
            cmd += libs

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
        self.time.new_local = ''
        self.to_link = self.time.check_link(self.local_src)
        if not MAKEMAIN or not self.to_link:
            return None

        cmd = "setlocal makeprg="

        compiler = CXX.strip()+' '
        compiler += LDFLAGS.strip()+' '

        cmd += compiler.replace(' ', '\ ')
        cmd += ''.join(self.local_inc)
        ## The order of libs matters
        libs = ''

        for key in self.map_set:
            if key == 'pthread' and self.to_link:
                libs += "-lpthread\ "
            elif key == 'root':
                if os.system('which root-config >& /dev/null') != 0:
                    continue
                include = os.popen('root-config --cflags').read().strip()
                include += ' '
                cmd += include.replace(' ', '\ ')
                if self.to_link:
                    lib = os.popen('root-config --glibs').read().strip()
                    lib += ' '
                    libs += lib.replace(' ', '\ ')
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
                libs += "-l%s\ " % key


        if len(libs) != 0:
            libs = "\ "+libs[:libs.rfind("\ ")]
        if self.is_main:
            cmd += self.time.get_objlist()
            cmd += libs
        else:
            cmd += "-c\ %"
            cmd += libs

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
            print "=========  %s : %d" % (key, len(val.items()))
            for key2,val2 in val.items():
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
        needcom = False
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
    import glob
    ### After run , move all the locale obj files to obj dir
    lcobj = glob.glob('*.o')
    if len(lcobj) != 0:
        ojpath = ObjFile().ojpath
        for objfile in lcobj:
            os.system("mv "+objfile+ " " + ojpath)

def ColorEcho(Status, cmd ):
    termCol = { 'default':'0', 'black':'30', 'red':'31', 'green':'32', \
               'yellow':'33', 'blue':'34', 'magenta':'35', 'cyan':'36',\
               'white':'37'}

    Message = "silent "
    ## Blue for current step
    if Status == "Compile":
        Message += "!clear; echo; echo -en \"> \e[4;"
        Message += termCol['yellow']+"mCompiling\e[0m : "
    elif Status == "Link":
        Message += "!echo; echo -en \"> \e[4;"
        Message += termCol['yellow']+"mLinking\e[0m : "

    lcmd = cmd.split(' ')
    col_map = {}
    target = -1
    found_target = False
    found_source = False

    for i,v in enumerate(lcmd):
        ### Use default color for all
        col_map[v] = 'default'
        ### High the compiler with cyan
        if i == 0:
            col_map[v]='blue'
        ### We care about the inputs
        if v == '-o':
            found_target = True
            target = i
            continue
        if v == '-c':
            found_source = True
            target = i
            continue
        ### The target file in red
        if found_target and i == target + 1:
            col_map[v]='red'
        ### The source file in green
        if found_target and i > target + 1:
            col_map[v]='green'
        if found_source and i > target:
            col_map[v]='green'
        if v.find('-l')== 0:
            temp = '-l'
            ### Highlight the linking library in magenta
            temp += "\e[" + termCol['magenta'] + 'm'
            temp += v[v.find('-l')+2:]
            lcmd[i] = temp
            col_map[temp] = 'default'
        if v.find('-I')== 0:
            temp = '-I'
            ### Highlight the linking library in magenta
            temp += "\e[" + termCol['cyan'] + 'm'
            temp += v[v.find('-I')+2:]
            lcmd[i] = temp
            col_map[temp] = 'default'

    out = ''
    for item in lcmd:
        out += "\e[" + termCol[col_map[item]]+'m'+item+' '
    Message += out
    Message += "\";tput sgr0; echo ;"

    if os.environ["SHELL"].find('tcsh') != -1:
        Message = Message.replace("echo -en", "echo -n")

    return Message

def fortune():
    import tempfile
    temf = tempfile.mkstemp()[1]
    #temf = os.popen('tempfile').read().strip()
    vimc = "silent !echo ;"
    vimc += "fortune -l zh"
    vimc += "| tee " + temf
    vim.command(vimc)
    f = ''.join(open(temf, 'r').readlines())
    fl=len(f)
    return fl/10

def MakeFortune():
    import timeit
    ft = fortune()
    try:
        t = timeit.Timer("vim.command('silent make')", "import vim").timeit(1)
        t += timeit.Timer("CleanObj()", "from __main__ import CleanObj").timeit(1)
    except:   
        vim.command("silent !echo \"Fuck with compiling. Enter Ctrl-C to continue ... \"")
        raise
    if ft - int(t) > 0 :
        wait = ft - int(t)
        vim.command("silent !echo \"Done with compiling. Enter Ctrl-C to continue ... \"")

        if len(vim.eval("getqflist()")) == 0:
            vim.command("let g:AutoMake = 'compile done'" )

        tosleep = "silent !sleep " + str(wait)
        try:
            vim.command(tosleep)
        except KeyboardInterrupt:   
            raise

if vim.eval("g:AutoMake") == "":
    todo = MakePrg()
    vim.command("let g:AutoMake = 'compile init'" )

EOF
"" End of python }}}

  try 
    call AutoMake()
  catch /.*/
    5sleep
    if g:AutoMake == "compile fuck"
      echoMsg "Compile interrupt!!"
    elseif g:AutoMake == "compile done"
      if empty(getqflist())
        call AutoMake()
      else 
        cwindow
      endif
    endif
    redraw!
    echo g:AutoMake
    5sleep
  endtry

  cd -

endfunction "}}}

map  <F4> :call MapAutoMake()<CR>
