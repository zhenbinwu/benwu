"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer: Zhenbin Wu <benwu@fnal.gov>
" 
" Annoucement: In this vimrc, I got lots of ideas from different places. 
" 	       Great thanks to all the sources!!
" 	1. Standard vimrc_example:
"          Modify for the vimrc_example.vim of vim71
"       2. Customizing common vim from easwy
"          URL: http://easwy.com/blog/
"       3. Customizing from the ultimate vim configuration of amix
"          Blog_post: http://amix.dk/vim/vimrc.html
"
" Sections:
"    -> General
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Command mode related
"    -> Moving around, tabs and buffers
"    -> Statusline
"    -> Parenthesis/bracket expanding
"    -> General Abbrevs
"    -> Editing mappings
"
"    -> QuickFix 
"    -> Minibuffer plugin
"    -> Omni complete functions
"    -> Python section
"    -> JavaScript section
"
" Plugins_Included:
"     ------> Common Plugins 
"     > SuperTab     ( V1.7    2011_11_06 ) 
"     > TagList      ( V4.5    2011_01_29 ) 
"     > Calendar     ( V2.5    2011_01_29 ) 
"     > LargeFile    ( V4      2011_01_29 ) 
"     > ShowMarks    ( V2.2    2011_01_29 ) 
"     > MarksBrowser ( V0.9    2011_01_29 ) 
"     > Recover      ( V0.11   2011_01_29 ) 
"     > Toggle       ( V0.5    2011_02_09 )
"     > Pathogen     ( V2.0    2011_10_26 ) 
"     > DirDiff      ( V1.1.4  2011_10_27 )
"     > Indent_py    ( V0.3    2011_07_24 )
"     > Python_fn    ( V1.13   2011_07_24 )
"     > Pydoc        ( V1.3.6  2011_07_24 )
"     > Pep8         ( V0.3.1  2011_07_24 ) 
"     > Pythoncomplete(V0.9    2011_09_01 )
"
"     ------> Plugins within Pathogen
"     > NERD_Tree        ( V4.1.0      2011_01_29 ) 
"     > WinManager       ( V2.3        2011_01_29 ) 
"     > BufExplorer      ( V7.2.8      2011_01_29 ) 
"     > Align            ( V35/41      2011_01_29 ) 
"     > VCSCommand       ( V1.99.45    2011_10_27 ) 
"     > XPtemplate       ( V0.4.8-0707 2011_10_27 ) 
"     > C-Support        ( V5.16       2011_11_06 ) 
"     > Conque Shell     ( V2.2        2011_10_27 ) 
"     > LaTeX-Suite      ( V1.5        2011_01_29 ) 
"     > ColorSamplerPack ( V8.03       2011_01_29 ) 
"     > OmniCppComplete  ( V0.41       2011_01_29 ) 
"     > VimGdb           ( V1.14       2011_01_29 )
"     > Matchit          ( V1.13.2     2011_01_29 )
"     > FuzzyFinder      ( V4.2.2      2011_01_30 )
"     > A                ( V2.18       2011_05_08 )
"     > Fswitch          ( V0.93       2011_05_08 )
"     > Taskpaper        ( v0.6        2011_05_29 )
"     > Cscope           ( V1          2011_01_30 )
"     > Pydiction        ( V1.2        2011_07_24 )
"     > Python_ifold     ( V2.9        2011_07_24 )
"     > Inccomplete      ( V1.6.29     2012_04_18 )
"     > NERD_Commenter   ( V2.3.0      2011_11_06 ) 


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Sets how many lines of history VIM has to remember
set history=5000

let g:pathogen_disabled = []
if v:version < '702'
  call add(g:pathogen_disabled, 'XPtemplate')
  call add(g:pathogen_disabled, 'FuzzyFinder')
  call add(g:pathogen_disabled, 'L9')
endif

call pathogen#infect()
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside 
set autoread

" With a map leader it's possible to do extra key combinations
let mapleader = ","
let g:mapleader = ","

	
" Fast saving
imap <leader>w :w!<cr>


" Fast editing of the .vimrc
map <leader>e :e! ~/.vimrc<cr>

" Fast reloading of the ~/.vimrc
map <leader>ss :w <CR> :source %<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the curors - when moving vertical..
set scrolloff=7

set wildmenu "Turn on WiLd menu
set wildmode=full

set ruler "Always show current position
set number "Always show the line number

" Set backspace config
set backspace=eol,start,indent
"--?> set whichwrap+=<,>,h,l

set ignorecase "Ignore case when searching

set hlsearch "Highlight search things

set incsearch "Make search act like search in modern browsers

set magic "Set magic on, for regular expressions

set showmatch "Show matching bracets when text indicator is over them
set matchtime=2 "How many tenths of a second to blink

set showcmd	" display incomplete commands

" In many terminal emulators the mouse works just fine, thus enable it.
set mouse=a

" No sound on errors
set noerrorbells
set novisualbell

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable "Enable syntax hl

" Set font according to system
"--?>   set guifont=Monospace\ 10
set shell=/bin/tcsh



if has("gui_running")
  set guioptions-=T
  set t_Co=256
  colorscheme peaksea
else
  if &term == 'linux'
    colorscheme anotherdark
  else
    set t_Co=256
    colorscheme wombat256
  endif
endif

let &termencoding = &encoding
set encoding=utf-8

set ffs=unix,dos,mac "Default file types


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files and backups
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nobackup
set writebackup

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=2
set tabstop=4
set smarttab

set linebreak
set textwidth=78

set autoindent "Auto indent
set smartindent  "Smart indet
set cindent     " C indent

set wrap "Wrap lines
set formatoptions+=mM
set isfname-==

"map <leader>t2 :setlocal shiftwidth=2<cr>
"map <leader>t4 :setlocal shiftwidth=4<cr>
"map <leader>t8 :setlocal shiftwidth=4<cr>

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Really useful!
"  In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSearch('gv')<CR>
nnoremap <expr>   gp '`[' . strpart(getregtype(), 0, 1) . '`]'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set foldmethod=marker
" Map space to / (search) and c-space to ? (backgwards search)
map <tab> :tabnext <ESC>
map <S-tab> :tabprevious <ESC>
map <silent> <leader><cr> :noh<cr>
map <silent> <leader>fo :set foldmethod=syntax<CR>
  		

" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
map <space> W
 
" Tab configuration
map <leader>tn :tabnew <cr>
map <leader>te :tabedit 
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 

" When pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h/..<cr>
map <leader>d :cd %:p:h<cr>

""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
" Always show the statusline
set laststatus=2
set statusline=%<\ \[%n:%Y]\ %f%m%r%h%w%q\ %=\ Line:%l\/%L\ Column:%c%V\ %P


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Abbrevs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Remap VIM 0
"map 0 ^

" My insert mode key mapping
inoremap <silent> <leader><leader> <ESC>
imap <silent> <leader>o <ESC>o
imap <silent> <leader>u <ESC>O
imap <silent> <leader>p <ESC>:call CopyLine()<CR>a
imap <silent> <leader>P <ESC>yyP

imap <silent> <leader>] <ESC>]]o
imap <silent> <leader>[ <ESC>[[o
imap <silent> <leader>h <ESC>ha
imap <silent> <leader>j <ESC>ja
imap <silent> <leader>k <ESC>ka
imap <silent> <leader>l <ESC>la
inoremap <silent> <C-]> <ESC>]}o
inoremap <silent> <C-b> <Backspace>
inoremap <silent> <C-h> <C-o>h
inoremap <silent> <C-k> <C-o>k
inoremap <silent> <C-l> <C-o>l
inoremap <silent> <C-g> <C-o>j

fun! CopyLine()
	let line=line('.')
	let col =col('.')
	let context=getline('.')
	let line2=line+1
	call append(line, context)
	call cursor(line2, col)
endfun

imap <silent> <leader>x <ESC>xi

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => QuickFix
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Do :help cope if you are unsure what quickfix is. It's super useful!
" Maping Keys compile the C++ program and get into quickfix
map <F2> <Esc>:w<CR>:make<CR>:cw<CR><CR>
map <F3> <Esc>:w<CR>:make %:r<CR>:cw<CR><CR>
map <F7> <Esc>:cp<CR>
map <F8> <Esc>:cn<CR>

imap <F2> <Esc>:w<CR>:make<CR>:cw<CR><CR>
imap <F3> <Esc>:w<CR>:make %:r<CR>:cw<CR><CR>
imap <F7> <Esc>:cp<CR>
imap <F8> <Esc>:cn<CR>
"""""""""""""""""""""""""""""""""""""""""""
" Buf Command
"""""""""""""""""""""""""""""""""""""""""'

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Pressing ,ss will toggle and untoggle spell checking
map <leader>s :setlocal spell!<cr>

"Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>sl z=

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Netrw Setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:netrw_winsize = 25

if(has('gdb'))
  """""""""""""""""""""""""""""""""""""
  " GDB Setting 
  """""""""""""""""""""""""""""""""""""
  set gdbprg=gdb	        	" set GDB invocation string (default 'gdb')
  set previewheight=12		" set gdb window initial height
  set asm=0				" don't show any assembly stuff
  "usource key mappings listed in this
  map <silent> <leader>gdb :run macros/gdb_mappings.vim<CR>
  let g:vimgdb_debug_file=""
endif

"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
"   								+
"                        Plugin Setting  			+
"   								+
"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

""""""""""""""""""""""""""""""""""""""""""""""
"" Super tab and Omnicomplete
""""""""""""""""""""""""""""""""""""""""""""""
let g:SuperTabMappingForward = "<tab>"
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabRetainCompletionType = 2
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabRetainCompletionDuration = 'completion'
""inoremap <expr> <CR>   pumvisible()?"\<C-Y>":"\<CR>"
""inoremap <expr> <C-f>  pumvisible()?"\<PageDown>\<C-N><C-P>":"\<C-f>"
""inoremap <expr> <C-U>  pumvisible()?"\<C-E>":"\<C-U>"
au CursorMovedI,InsertLeave * if pumvisible()==0| silent! pclose |endif
""set completeopt-=preview
set include="#include \\(<boost\\)\\@!"

"""""""""""""""""""""""""""""""""
" Tag List (ctags)
""""""""""""""""""""""""""""""""""
if( match(hostname(), 'nbay') >=0 )
  let Tlist_Ctags_Cmd='/mnt/autofs/misc/nbay05.a/benwu/BenSys/bin/ctags'
else 
  let Tlist_Ctags_Cmd='/usr/bin/ctags'
endif
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_SingleClick = 1
let Tlist_Auto_Open = 0
let Tlist_File_Fold_Auto_Close = 1
let Tlist_GainFocus_On_ToggleOpen = 1
set updatetime=2000
set tags=tags;/
let tlist_tex_settings   = 'latex;s:sections;g:graphics;l:labels;r:refs;f:frames'
map <silent> <F9> :TlistToggle<CR>

""""""""""""""""""""""""""""""""""""""""""""""
" Calendar
""""""""""""""""""""""""""""""""""""""""""""""
let g:calendar_diary = "~/.daily_note"
nmap <unique> <Leader>ch <Plug>CalendarH

""""""""""""""""""""""""""""""""""""""""
" WinManager Setting
""""""""""""""""""""""""""""""""""""""""
let g:winManagerWindowLayout = 'TagList,NERDTree|BufExplorer'
let g:winManagerWidth = 30
let g:persistentBehaviour = 0
let g:defaultExplorer = 0
map <silent> <F12> :WMToggle<CR>

""""""""""""""""""""""""""""""
" BufExplorer Setting
""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerSortBy='mru'

""""""""""""""""""""""""""""""""""
" XPTemplate
""""""""""""""""""""""""""""""
let g:xptemplate_key = '<C-\>' 
let g:xptemplate_nav_next = '<C-j>' 
let g:xptemplate_nav_prev = '<C-k>' 
let g:xptemplate_brace_complete = '([{"' 
let g:xptemplate_vars = "SParg=&$author=Ben Wu&$email=benwu@fnal.gov"

""""""""""""""""""""""""""""""
" ShowMarks setting
"""""""""""""""""""""""""""""""
" " Enable ShowMarks
let showmarks_enable = 0
" " Show which marks
let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
" " Ignore help, quickfix, non-modifiable buffers
let showmarks_ignore_type = "hqm"
" " Hilight lower & upper marks
let showmarks_hlline_lower = 1
let showmarks_hlline_upper = 1 

" For showmarks plugin
"hi ShowMarksHLl ctermbg=Yellow ctermfg=Black guibg=#FFDB72 guifg=Black
hi ShowMarksHLl ctermbg=lightcyan  ctermfg=Black guibg=#FFDB72 guifg=Black
hi ShowMarksHLu ctermbg=Magenta ctermfg=Black guibg=#FFB3FF guifg=Black

imap <silent> <Leader>mt <Esc><Leader>mt i
imap <silent> <Leader>mo <Esc><Leader>mo i
imap <silent> <Leader>mh <Esc><Leader>mh i
imap <silent> <Leader>ma <Esc><Leader>ma i
imap <silent> <Leader>mm <Esc><Leader>mm i

"""""""""""""""""""""""""""""
" MarkBrowser setting
"""""""""""""""""""""""""""""""
nmap <silent> <leader>mk :MarksBrowser<CR>
imap <silent> <Leader>mk <Esc>:MarksBrowser<CR>



""""""""""""""""""""""""""""""""""""""""'
" C Support
"""""""""""""""""""""""""""""""""""""""""""
let g:C_MapLeader = ','
let g:C_Styles = { '*.c,*.h' : 'default', '*.C,*.cc,*.cpp,*.hh' : 'CPP' }
au FileType c let dictionary=g:C_Dictionary_File
""set dictionary=/usr/share/dict/words 

"""""""""""""""""""""""""""""""""""""""""'
" Vim Latex_Suite
""""""""""""""""""""""""""""""""""""""""""""
" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex' 
let g:Tex_DefaultTargetFormat='dvi'
"let g:Tex_DefaultTargetFormat='pdf'
"let g:Tex_FormatDependency_pdf = 'dvi,ps,pdf'
let g:Tex_CompileRule_dvi = 'latex -src-specials --interaction=nonstopmode $*'
let g:Tex_CompileRule_ps = 'dvips -Ppdf -o $*.ps $*.dvi'
"let g:Tex_CompileRule_pdf = 'ps2pdf $*.ps'
let g:Tex_CompileRule_pdf='pdflatex -shell-escape -src-specials -interaction=nonstopmode $*' 
if &term == 'linux'
  """ For framebuffer only
  let g:Tex_ViewRule_pdf='fbgs'
  let g:Tex_ViewRule_dvi='dvifb'
  let g:Tex_ExecuteUNIXViewerInForeground = 1 "For dvifb 
else
  "let g:Tex_ViewRule_pdf='acroread'
  let g:Tex_ViewRule_pdf='xpdf -remote vimlatex'
  let g:Tex_ViewRule_dvi='xdvi'
endif
let g:Tex_ViewRule_ps='gv'
let g:Tex_UseEditorSettingInDVIViewer=1
let g:Tex_FoldedEnvironments=',frame'

"""""""""""""""""""""""""""""""""""""""""""""""
" Conque Term
""""""""""""""""""""""""""""""""""""""""""""""
nmap <silent> <leader>sh :ConqueTermSplit tcsh<CR>
nmap <silent> <leader>sv :ConqueTermVSplit tcsh<CR>
nmap <silent> <leader>st :ConqueTermTab tcsh<CR>
let g:ConqueTerm_CWInsert = 1
let g:ConqueTerm_SendVisKey = '<F9>'
let g:ConqueTerm_TERM = 'xterm'
let g:ConqueTerm_ReadUnfocused = 1


""""""""""""""""""""""""""""""
" => Vim grep
""""""""""""""""""""""""""""""
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated'
set grepprg=/bin/grep\ -nH\ $*


""""""""""""""""""""""""""""""""""""""""""
" Fuzzyfinder  
""""""""""""""""""""""""""""""""""""""""""
nmap fff <ESC>:FufFile<CR>
nmap ffb <ESC>:FufBuffer<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => MISC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
"noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

"""""""""""""""""''
" Alternate 
"""""""""""""""""""""""'
let g:alternateSearchPath = 'sfr:../source,sfr:./Powheg,sfr:../src,sfr:../include,sfr:../inc,sfr:../, sfr:./BWWH/'
let g:alternateNoDefaultAlternate = 0
let g:alternateExtensions_CPP = "inc,h,hh,H,HPP,hpp"
nmap <Leader>a :A<CR>
imap <Leader>a <ESC>:A<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Pydiction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:pydiction_location = '~/.vim/bundle/Pydiction/complete-dict'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Pyflakes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:pyflakes_use_quickfix = 0
let g:pyflakes_autostart = 0
map <F3> :PyflakesToggle<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Pep8
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:pep8_map='<F4>'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Elog
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:netrw_http_cmd = "elinks"
let g:netrw_http_xcmd = "-dump -dump-width 400 -no-references -no-numbering >"
com! -nargs=? Elog :tabedit http://hep05.baylor.edu/elog/benwu/<args>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => TaskPaper
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:task_paper_date_format = "%Y-%m-%d  %H:%M:%S"
com! -nargs=0 Task :tabedit ~/.daily_note/${USER}.taskpaper 



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => DirDiff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:DirDiffExcludes = "CVS, objects,*.root,*Backup*,*.log,*.eps,*.gif,*.class,*.o,*.so,*.d,*.exe,.*.swp, *~"
let g:DirDiffIgnore = "Id:,Revision:,Date:"
let g:DirDiffWindowSize = 14

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Pythoncomplete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd filetype python set omnifunc=pythoncomplete#Complete

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Inccomplete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:inccomplete_addclosebracket='no'
let g:inccomplete_appendslash = 1

