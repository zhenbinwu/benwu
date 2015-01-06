""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer: Zhenbin Wu <benwu@fnal.gov>
" 
" Annoucement: In this vimrc, I got lots of ideas from different places. 
" 	       Great thanks to all the sources!!
" 	    1. Standard vimrc_example:
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
"     > SuperTab         ( V2.0        2012_06_17 )
"     > TagList          ( V4.6        2013_05_31 )
"     > Calendar         ( V2.5        2011_01_29 )
"     > LargeFile        ( V4          2011_01_29 )
"     > ShowMarks        ( V2.2        2011_01_29 )
"     > MarksBrowser     ( V0.9        2011_01_29 )
"     > Recover          ( V0.16       2012_11_22 )
"     > Toggle           ( V0.5        2011_02_09 )
"     > Pathogen         ( V2.2        2012_01_14 )
"     > DirDiff          ( V1.1.4      2011_10_27 )
"     > Indent_py        ( V0.3        2011_07_24 )
"     > Python_fn        ( V1.13       2011_07_24 )
"     > Pydoc            ( V2.0        2013_05_24 )
"     > Pep8             ( V0.3.1      2011_07_24 )
"     > Pythoncomplete   ( V0.9        2011_09_01 )
"     > SrollColors      ( V0719       2012_05_09 )
"     > Repmo            ( V0.5.1      2013_01_15 ) 
"     > Ambicomplete     ( V0.2a       2012_08_11 )
"
"     ------> Plugins within Pathogen
"     > NERD_Tree        ( V4.2.0      2013_05_24 )
"     > WinManager       ( V2.3        2011_01_29 ) 
"     > BufExplorer      ( V7.3.6      2013_05_31 )
"     > Align            ( V36/42      2012_11_25 ) 
"     > VCSCommand       ( V1.99.47    2013_05_31 )
"     > XPtemplate       ( V0.4.8-1201 2013_05_31 )
"     > C-Support        ( V5.16       2011_11_06 ) 
"     > Conque Shell     ( V2.2        2011_10_27 )   
"     > LaTeX-Suite      ( V1.5        2011_01_29 ) 
"     > ColorSamplerPack ( V8.03       2011_01_29 )  " 
"     > OmniCppComplete  ( V0.41       2011_01_29 ) 
"     > VimGdb           ( V1.14       2011_01_29 )
"     > Matchit          ( V1.13.2     2011_01_29 )
"     > FuzzyFinder      ( V4.2.2      2011_01_30 )
"     > A                ( V2.18       2011_05_08 )
"     > Taskpaper        ( v0.7        2013_05_26 )
"     > Cscope           ( V1          2011_01_30 )
"     > Pydiction        ( V1.2        2011_07_24 )
"     > Python_ifold     ( V2.9        2011_07_24 )
"     > Inccomplete      ( V1.6.32     2013_01_16 ) 
"     > NERD_Commenter   ( V2.3.0      2012_06_17 ) 
"     > Repeat           ( V1.1        2013_05_24 )
"     > Surrond          ( V2.0        2013_05_24 )
"     > Tagbar           ( V2.5        2013_05_24 )
"     > Fugitive         ( V2.1        2014_06_27 )
"     > Gitv             ( V1.1        2012_07_14 )
"     > TextObj          ( V0.3.12     2012_07_15 )
"     > RelOps           ( V1.0        2012_09_13 )  " 
"     > Sideways         ( V0.0.2      2012_10_08 )
"     > Powerline        ( V#beta      2012_11_22 )
"     > Locator          ( V1.3        2012_11_25 )
"     > Syntastic        ( V2.3.0      2012_11_25 )
"     > Project          ( V1.4.1      2012_12_22 )
"     > AsyncCommand     ( V4.0        2012_12_27 )
"     > R-plugin         ( V0.9.9.1    2013_01_29 )
"     > Startify         ( V1.3        2013_05_01 )
"     > ClangComplete    ( V2.0        2013_05_24 )
"     > Gist             ( V7.1        2014_09_22 )


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Sets how many lines of history VIM has to remember
set history=5000

let g:pathogen_disabled = []

"" Limitation of Vim
if v:version < '702'
  call add(g:pathogen_disabled, 'XPtemplate')
  call add(g:pathogen_disabled, 'FuzzyFinder')
  call add(g:pathogen_disabled, 'L9')
endif
if v:version < '703'
  call add(g:pathogen_disabled, 'Gundo')
endif

"" Limitation of Python
if has('python')
python << EOF
import sys
import os
import vim

ToDis = vim.eval("g:pathogen_disabled")

if sys.version_info[:2] < (2, 6):
    ToDis.append('Python_Jedi')
    ToDis.append('Python_mode')
else:
    ToDis.append('Pydiction')
    ToDis.append('Pyflakes')
    ToDis.append('Python_Com')

if sys.version_info[:2] < (2, 5):
    ToDis.append('Pyflakes')

if sys.version_info[:2] < (2, 3):
    ToDis.append('Pydiction')

## Limitation of Clang
if vim.eval("executable('clang')") == '1':
    ToDis.append('OmniCppComplete')
else:
    ToDis.append('ClangComplete')


## If python version is too low, revert the ClangComplete
if sys.version_info[:2] < (2, 5):
    ToDis.append('ClangComplete')
    if 'OmniCppComplete' in ToDis:
        ToDis.remove('OmniCppComplete')

vim.command("let g:pathogen_disabled =  %s" % list(set(ToDis)))
EOF
endif

call pathogen#infect()

filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside 
set autoread

" With a map leader it's possible to do extra key combinations
let mapleader = ","
let maplocalleader = ","
let g:mapleader = ","

" Fast editing of the .vimrc
map <leader>v :e! ~/.vimrc<cr>

" Fast reloading of the ~/.vimrc
au FileType vim map <leader>ss :w <CR> :source %<CR>

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
  set guioptions-=m
  set guioptions-=r
  set guioptions-=L
  set nocursorline
  set t_Co=256
  colorscheme harlequin
else
  if &term == 'linux' || &term == 'jfbterm' || &term == 'screen'
    set t_Co=256
    colorscheme anotherdark
  else
    if( match(hostname(), 'hep') >=0 )
      colorscheme benwu
    else 
      set t_Co=256
      colorscheme harlequin
    endif
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

set autoindent  " Auto indent
set smartindent " Smart indet
set cindent     " C indent

set wrap        " Wrap lines
set formatoptions+=mM
set isfname-==

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" In visual mode when you press * or # to search for the current selection
" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" When you press gv you vimgrep after the selected text
nnoremap <expr>   gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" map & and g& for visual mode, also work for visual block
vnoremap &  :s<CR>
vnoremap g& :s/\%V<C-R>//~/g<CR>:let @/ = substitute(@/, '\v^\\\%V(.*)', '\1', '')<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set foldmethod=marker
" Map space to / (search) and c-space to ? (backgwards search)
map <tab> :tabnext <ESC>
map <silent> <leader><cr> :noh<cr>
map <silent> <leader>z :set foldmethod=syntax<CR>
map <silent> zu :checktime<CR>

"" Map to go through the buffer list
map <silent> g<space> :bnext<CR>
map <silent> g<Enter> :bprevious<CR>
  		

" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
map <space> W
 
" Tab configuration
map <leader>tn :tabnew 
map <leader>te :tabedit 
map <leader>tz :tabclose<cr>
map <leader>tm :tabmove 

" When pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h/..<cr>
map <leader>d :cd %:p:h<cr>

map <F9> :redraw!<cr>
nnoremap <leader>p :set invpaste paste?<CR>i
nnoremap <C-\><C-\> <tab>
""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
" Always show the statusline
set laststatus=2
set statusline=%<\ \[%n:%Y]\ %f%m%r%h%w\ %=\ Line:%l\/%L\ Column:%c%V\ %P

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Abbrevs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iab xdate <c-r>=strftime("%d/%m/%Y %H:%M:%S")<cr>
command! -nargs=* Q q!

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
imap <silent> <leader>s <ESC>:w<CR>a
nnoremap <silent> S :w<CR>

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

fun! CopyLine()"{{{
	let line=line('.')
	let col =col('.')
	let context=getline('.')
	let line2=line+1
	call append(line, context)
	call cursor(line2, col)
endfun"}}}

"This allows for change paste motion cp{motion}
noremap <silent> cp :set opfunc=ChangePaste<CR>g@
function! ChangePaste(type, ...) "{{{
  silent exe "normal! `[v`]\"_c"
  silent exe "normal! p"
endfunction "}}}

"Inserting word quickly in normal mode
"Same keystroke as i<ESC>, but saving the movement to <ESC>
function! InsertWord()"{{{
  let l:user_word = input("Insert something then hit ENTER: ")

  let l:current = getpos(".")
  normal b
  let l:currentb = getpos(".")
  normal e
  let l:currente = getpos(".")
  call setpos('.', l:current)

  if l:current[2] == 1 
    execute "normal i".l:user_word." "
    return ""
  endif

  if l:current[2] == (col('$')-1)
    execute "normal a ".l:user_word
    return ""
  endif

  if l:current[2] > l:currentb[2] && l:current[2] < l:currente[2] 
    execute "normal i".l:user_word
    return ""
  endif

  if l:current[2] > l:currentb[2] && l:current[2] > l:currente[2]
    execute "normal i".l:user_word." "
    return ""
  endif

  if l:current[2] > l:currentb[2] && l:current[2] == l:currente[2] 
    execute "normal a ".l:user_word
    return ""
  endif
endfunction"}}}

nnoremap gc :call InsertWord()<CR>

"Inserting a character quickly in normal mode
nnoremap gs :exec "normal i".nr2char(getchar())."\e"<CR>
nnoremap ga :exec "normal a".nr2char(getchar())."\e"<CR>

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
  set gdbprg=gdb	        " set GDB invocation string (default 'gdb')
  set previewheight=12		" set gdb window initial height
  set asm=0				    " don't show any assembly stuff
  "usource key mappings listed in this
  map <silent> <leader>gdb :run macros/gdb_mappings.vim<CR>
  let g:vimgdb_debug_file=""
endif

""""""""""""""""""""""""""""""""""""""""""""""
"" Map for dict with the word under cursor
""""""""""""""""""""""""""""""""""""""""""""""
noremap <leader>o mayiw`a:exe "!kdict " . @" . "" <CR><CR>
"noremap <leader>o mayiw`a:exe "!dict " . @" . "" <CR><CR>


""""""""""""""""""""""""""""""""""""""""""""""
"" New From Vim 7.3
""""""""""""""""""""""""""""""""""""""""""""""
if v:version >= '703'
  set undodir=$HOME/.vim/undo
  set undofile

  fun! OnlyGundo() "{{{
    if exists(":WMClose") == 2
      :WMClose
    endif
    :GundoToggle
  endfunction "}}}
  map <silent> <F11> :call OnlyGundo()<CR>
  let g:gundo_width = 30
  let g:gundo_preview_height = 20
  let g:gundo_close_on_revert = 1
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Man
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("unix")
  runtime ftplugin/man.vim
  autocmd FileType man setlocal ro nonumber nolist fdm=indent fdn=2 sw=4 foldlevel=2 | nmap <buffer> q :quit<CR>
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Preview Window Zoom
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufWinEnter * call PreviewMap()

fun! PreviewMap() "{{{
  if &pvw || &filetype == "help"
    if &pvw
      nnoremap <buffer> <silent> q :pclose<CR>
    else
      nnoremap <buffer> <silent> q :close<CR>
    endif
    let s:preview_win_height = winheight(0)
    let s:preview_win_maximized = 0
    nnoremap <buffer> <silent> x :call <SID>PreviewZoom()<CR>
  endif
endfunction "}}}

fun! s:PreviewZoom() "{{{
  if s:preview_win_maximized
    " Restore the window back to the previous size
    exe 'resize ' . s:preview_win_height
    let s:preview_win_maximized = 0
  else
    " Set the window size to the maximum possible without closing other
    " windows
    resize
    let s:preview_win_maximized = 1
  endif
endfunction "}}}

map <C-W>[ <C-W>g<C-]>
map <C-W>{ <C-W>g}

"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
"   							                            	+
"                        Plugin Setting             			+
"   							                            	+
"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
fun! SearchFile(filename) "{{{
    let curdir = getcwd()
    while !filereadable(a:filename) && getcwd() != '/' && split(getcwd(),'/')[-1] != expand("$USER")
      lcd ..
    endwhile

    if filereadable(a:filename)
      let s:filepath = getcwd()
      execute "lcd " . curdir
      return s:filepath . "/" . a:filename
    else
      execute "lcd " . curdir
      return ''
    end
endfunction "}}}

""""""""""""""""""""""""""""""""""""""""""""""
"" Super tab and Omnicomplete
""""""""""""""""""""""""""""""""""""""""""""""
let g:SuperTabMappingForward = "<tab>"
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabRetainCompletionType = 2
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabRetainCompletionDuration = 'completion'
inoremap <expr> <C-f>  pumvisible()?"\<PageDown>\<C-N><C-P>":"\<C-f>"
inoremap <expr> <C-b>  pumvisible()?"\<PageUp>\<C-N><C-P>":"\<C-b>"
au CursorMovedI,InsertLeave * if pumvisible()==0| silent! pclose |endif
"set completeopt-=preview
set include="#include \\(<boost\\)\\@!"

"""""""""""""""""""""""""""""""""
" Tag List (ctags)
""""""""""""""""""""""""""""""""""
if( match(hostname(), 'nbay') >=0 )
  let Tlist_Ctags_Cmd='/mnt/autofs/misc/nbay05.a/benwu/BenSys/bin/ctags'
else 
  let Tlist_Ctags_Cmd='/usr/bin/ctags'
endif
let Tlist_Exit_OnlyWindow         = 1
let Tlist_Use_SingleClick         = 1
let Tlist_Auto_Open               = 0
let Tlist_File_Fold_Auto_Close    = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let tlist_tex_settings            = 'latex;s:sections;g:graphics;l:labels;r:refs;f:frames'
set updatetime=1000
set tags=tags;/

""""""""""""""""""""""""""""""""""""""""""""""
" Calendar
""""""""""""""""""""""""""""""""""""""""""""""
let g:calendar_datetime = 'title'
let g:calendar_diary = "~/.daily_note"
nmap <silent> <Leader>cah <Plug>CalendarH

""""""""""""""""""""""""""""""""""""""""
" WinManager Setting
""""""""""""""""""""""""""""""""""""""""
let g:winManagerWindowLayout = 'TagList,NERDTree|BufExplorer'
let g:winManagerWidth        = 30
let g:persistentBehaviour    = 0
let g:defaultExplorer        = 0
map <silent> <F12> :call OnlyWin()<CR>
fun! OnlyWin() "{{{
  if exists("g:gundo_target_n") && exists(":GundoHide") == 2
    :GundoHide
  endif
  :WMToggle
endfunction "}}}


""""""""""""""""""""""""""""""""""""""""
" NERDTree Setting
""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeMapChdir           = 'd'
let g:NERDTreeMapJumpNextSibling = 'gj'
let g:NERDTreeMapJumpPrevSibling = 'gk'
let g:NERDTreeMapOpenSplit       = 's'
let g:NERDTreeMapOpenVSplit      = 'v'
let g:NERDTreeMapToggleZoom      = 'x'
let g:NERDTreeMapCloseDir        = 'c'
let g:NERDTreeMapCloseChildren   = 'C'
let g:NERDTreeMapChangeRoot      = 'X'
let NERDTreeIgnore               = ['\~$']
let NERDTreeWinSize              = 30
let NERDTreeDirArrows            = 0
let g:nerdtree_open_cmd          = 'gnome-open'
exe 'nnoremap gb :!' . g:nerdtree_open_cmd . ' <cfile> &<CR><CR>'
nmap <silent> <Leader>g :NERDTreeToggle<CR>:redraw!<CR>

""""""""""""""""""""""""""""""
" BufExplorer Setting
""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp      = 0
let g:bufExplorerShowRelativePath = 1
let g:bufExplorerSortBy           = 'mru'
nmap <silent> <Leader>le :BufExplorer<CR>
nmap <silent> <Leader>ls :BufExplorerHorizontalSplit<CR>
nmap <silent> <Leader>lv :BufExplorerVerticalSplit<CR>
nmap <silent> <Leader>lt :BufExplorerTab<CR>


""""""""""""""""""""""""""""""""""
" XPTemplate
""""""""""""""""""""""""""""""
let g:xptemplate_key            = '<C-\>'
let g:xptemplate_nav_next       = '<C-j>'
let g:xptemplate_nav_prev       = '<C-k>'
let g:xptemplate_brace_complete = '([{"'
let g:xptemplate_vars           = "SParg=&$author=Ben Wu&$email=benwu@fnal.gov"

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
hi ShowMarksHLl ctermbg=lightcyan ctermfg=Black guibg=#FFDB72 guifg=Black
hi ShowMarksHLu ctermbg=Magenta   ctermfg=Black guibg=#FFB3FF guifg=Black

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
let g:C_Styles = { '*.c' : 'default', '*.C,*.cc,*.cpp,*.hh,*.h' : 'CPP' }
au FileType c let dictionary=g:C_Dictionary_File
""set dictionary=/usr/share/dict/words 
let g:C_LineEndCommColDefault    = 35

"""""""""""""""""""""""""""""""""""""""""'
" Vim Latex_Suite
""""""""""""""""""""""""""""""""""""""""""""
" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor                = 'latex'
"let g:Tex_DefaultTargetFormat   = 'dvi'
let g:Tex_DefaultTargetFormat  = 'pdf'
"let g:Tex_FormatDependency_pdf = 'dvi,ps,pdf'
"let g:Tex_FormatDependency_pdf  = 'dvi,pdf'
"let g:Tex_CompileRule_dvi       = 'latex -src-specials --interaction=nonstopmode $*'
"let g:Tex_CompileRule_ps       = 'dvips -Ppdf -o $*.ps $*.dvi'
"let g:Tex_CompileRule_pdf      = 'ps2pdf $*.ps'
"let g:Tex_CompileRule_pdf       = 'dvipdfm $*.dvi'
let g:Tex_CompileRule_pdf      = 'pdflatex -shell-escape -src-specials -interaction=nonstopmode $*'
let g:Tex_IgnoredWarnings       =
    \"Underfull\n".
    \"Overfull\n".
    \"specifier changed to\n".
    \"You have requested\n".
    \"Missing number, treated as zero.\n".
    \"There were undefined references\n".
    \"Citation %.%# undefined\n".
    \"LaTex Font Warning:"
let g:Tex_IgnoreLevel           = 8

if &term == 'linux'
  """ For framebuffer only
  let g:Tex_ViewRule_pdf='fbgs'
  let g:Tex_ViewRule_dvi='dvifb'
  let g:Tex_ExecuteUNIXViewerInForeground = 1 "For dvifb 
else
  "let g:Tex_ViewRule_pdf='acroread'
  let g:Tex_ViewRule_pdf='okular'
  "let g:Tex_ViewRule_pdf='xpdf -remote benwu'
  "let g:Tex_ViewRule_dvi='xdvi'
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
let g:ConqueTerm_CWInsert      = 1
let g:ConqueTerm_SendVisKey    = '<F9>'
let g:ConqueTerm_TERM          = 'xterm'
let g:ConqueTerm_ReadUnfocused = 1
let g:ConqueTerm_InsertOnEnter = 0

""""""""""""""""""""""""""""""
" => Vim grep
""""""""""""""""""""""""""""""
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated'
set grepprg=/bin/grep\ -nH\ $*


""""""""""""""""""""""""""""""""""""""""""
" Fuzzyfinder  
""""""""""""""""""""""""""""""""""""""""""
let g:fuf_modesDisable        = [ 'coveragefile', 'quickfix', 'line', 'help', 'givenfile', 'givendir', 'givencmd', 'callbackfile', 'callbackitem']
let g:fuf_mrufile_switchOrder = 20
let g:fuf_mrufile_maxItem     = 100
let g:fuf_mrucmd_maxItem      = 100
let g:fuf_previewHeight       = 10
let g:fuf_mrufile_exclude     = '\v\~$|\.(o|exe|dll|bak|orig|sw[po])$|^(\/\/|\\\\|\/media\/)'
nnoremap <silent> gnb :FufBuffer<CR>
nnoremap <silent> gnf :FufFile<CR>
nnoremap <silent> gnd :FufDir<CR>
nnoremap <silent> gnn :FufMruFile<CR>
nnoremap <silent> gnm :FufMruFileInCwd<CR>
nnoremap <silent> gnc :FufMruCmd<CR>
nnoremap <silent> gnj :FufJumpList<CR>
nnoremap <silent> gnh :FufChangeList<CR>
nnoremap <silent> gnk :FufBookmarkFile<CR>
nnoremap <silent> gna :FufBookmarkFileAdd<CR>
nnoremap <silent> gnr :FufBookmarkDir<CR>
nnoremap <silent> gni :FufBookmarkDirAdd<CR>
nnoremap <silent> gnt :FufTag<CR>
nnoremap <silent> gnw :FufTagWithCursorWord<CR>
nnoremap <silent> gne :FufBufferTag<CR>
nnoremap <silent> gn[ :FufBufferTagWithCursorWord!<CR>
nnoremap <silent> gnl :FufBufferTagAll<CR>
nnoremap <silent> gn] :FufBufferTagAllWithCursorWord!<CR>
nnoremap <silent> gng :FufTaggedFile<CR>
nnoremap <silent> gnz :FufFileWithCurrentBufferDir<CR>
nnoremap <silent> gnx :FufFileWithFullCwd<CR>
nnoremap <silent> gnp :FufDirWithCurrentBufferDir<CR>
nnoremap <silent> gno :FufDirWithFullCwd<CR>
"gn:q s u v y 

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => MISC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
"noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Alternate 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:alternateSearchPath         = 'sfr:../,'
let g:alternateSearchPath        .= 'sfr:src,sfr:inc,reg:/inc/src/g/,reg:/src/inc/g/,'
let g:alternateSearchPath        .= 'sfr:source,sfr:include,reg:/include/source/g/,reg:/source/include/g/'
let g:alternateSearchPath        .= 'sfr:src,sfr:interface,reg:/.*\zsinterface/src/g/,reg:/.*\zssrc/interface/g/,' "CMSSW style 
let g:alternateSearchPath        .= 'sfr:src,sfr:WHAM,reg:/WHAM/src/g/,reg:/src/WHAM/g/,'                "WHAM style 
let g:alternateNoDefaultAlternate = 1
let g:alternateExtensions_CPP     = "inc,h,hh,H,HPP,hpp"
let g:alternateExtensions_C       = "inc,h,hh,H,HPP,hpp"
nmap <Leader>aa :A<CR>
nmap <Leader>as :AS<CR>
nmap <Leader>av :AV<CR>
nmap <Leader>at :AT<CR>
nmap <Leader>ha :IH<CR>
nmap <Leader>hs :IHS<CR>
nmap <Leader>hv :IHV<CR>
nmap <Leader>ht :IHT<CR>
imap <Leader>aa <ESC>:w<CR>:A<CR>
imap <Leader>as <ESC>:w<CR>:AS<CR>
imap <Leader>av <ESC>:w<CR>:AV<CR>
imap <Leader>at <ESC>:w<CR>:AT<CR>
imap <Leader>ha <ESC>:w<CR>:IH<CR>
imap <Leader>hs <ESC>:w<CR>:IHS<CR>
imap <Leader>hv <ESC>:w<CR>:IHV<CR>
imap <Leader>ht <ESC>:w<CR>:IHT<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Pydiction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:pydiction_location = '~/.vim/bundle/Pydiction/complete-dict'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Pyflakes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:pyflakes_use_quickfix = 1
let g:pyflakes_autostart    = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Pep8
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:pep8_map='<F4>'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Elog
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:netrw_http_cmd  = "elinks"
let g:netrw_http_xcmd = "-dump -dump-width 400 -no-references -no-numbering >"
com! -nargs=? Elog :tabedit http://hep05.baylor.edu/elog/benwu/<args>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => TaskPaper
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:task_paper_date_format = "%Y-%m-%d  %H:%M:%S"
com! -nargs=? -complete=customlist,s:TaskpaperComplete Task :call s:Taskpaper(<q-args>)
fun! s:TaskpaperComplete(A, L, P) "{{{
  let dtask = globpath("~/.daily_note/", "*.taskpaper")
  let tasklist = []

  for tak in split(dtask, "\n")
    call add(tasklist, split(split(tak, "\/")[-1], '\.')[0])
  endfor
  return tasklist
endfunction "}}}

fun! s:Taskpaper(...) "{{{
  if a:1 == ""
    exec "tabedit ~/.daily_note/${USER}.taskpaper" 
    return
  else
    exec "tabedit ~/.daily_note/" . a:1 . ".taskpaper"
    return
  endif
endfunction "}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => DirDiff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:DirDiffExcludes   = "CVS,objects,*.root,*Backup*,*.log,*.eps,*.gif,*.class,*.o,*.so,*.d,*.exe,.*.swp, *~"
let g:DirDiffIgnore     = "Id:,Revision:,Date:"
let g:DirDiffWindowSize = 14

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Pythoncomplete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd filetype python set omnifunc=pythoncomplete#Complete

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Inccomplete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:inccomplete_addclosebracket = 'no'
let g:inccomplete_appendslash     = 1
"Temporary disable inccomplete due to the conflict with CppOmnicomplete
let g:loaded_inccomplete = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => EasyMotion
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:EasyMotion_keys       = 'abceghimnopqrtuvwxyzsldfjk'
"let g:EasyMotion_keys      = 'abceghimnopqrtuvwxyzABCEGHIMNOPQRTUVWXYZSLDFJKsldfjk'
let g:EasyMotion_mapping_w  = '<leader>w'
let g:EasyMotion_mapping_W  = '<leader>W'
let g:EasyMotion_mapping_b  = '<leader>b'
let g:EasyMotion_mapping_B  = '<leader>B'
let g:EasyMotion_mapping_e  = '<leader>e'
let g:EasyMotion_mapping_E  = '<leader>E'
let g:EasyMotion_mapping_ge = '<leader>me'
let g:EasyMotion_mapping_gE = '<leader>mE'
let g:EasyMotion_mapping_f  = '<leader>f'
let g:EasyMotion_mapping_F  = '<leader>F'
let g:EasyMotion_mapping_n  = '<leader>n'
let g:EasyMotion_mapping_N  = '<leader>N'
let g:EasyMotion_mapping_j  = '<leader>j'
let g:EasyMotion_mapping_k  = '<leader>k'
imap <leader>w <ESC><leader>w
imap <leader>W <ESC><leader>W
imap <leader>b <ESC><leader>b
imap <leader>B <ESC><leader>B
imap <leader>e <ESC><leader>e
imap <leader>E <ESC><leader>E
imap <leader>f <ESC><leader>f
imap <leader>F <ESC><leader>F
imap <leader>n <ESC><leader>n
imap <leader>N <ESC><leader>N
imap <leader>j <ESC><leader>j
imap <leader>k <ESC><leader>k


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => YankRing
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:yankring_history_dir        = '$HOME/.vim/'
let g:yankring_history_file       = '.vim_yankring_history_file'
let g:yankring_min_element_length = 2
let g:yankring_paste_using_g      = 0
let g:yankring_default_menu_mode  = 0
let g:yankring_ignore_operator    = 'g~ gu gU ! = gq g? > < zf g@'
let g:yankring_max_element_length = 524288 " 0.5M
nnoremap <silent> <leader>y :YRShow<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Indent_Guide
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:indent_guides_guide_size=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VimIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vimim_cloud  = 'sogou,2'
let g:vimim_toggle = 'pinyin,sogou'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Tagbar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <silent> <F10>  :TagbarToggle<CR>
let g:tagbar_width = 30

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Align
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Complex C-code alignment maps: 
map <Leader>ab   <Plug>AM_abox
map <Leader>ac   <Plug>AM_adcom
map <Leader>ad   <Plug>AM_adec
map <Leader>af   <Plug>AM_afnc
map <Leader>an   <Plug>AM_anum
map <Leader>au   <Plug>AM_aunum
map <Leader>ae   <Plug>AM_aenum
map <Leader>a#   <Plug>AM_adef
" character-based right-justified alignment maps 
map <Leader>r| <Plug>AM_T|
map <Leader>r#   <Plug>AM_T#
map <Leader>r,   <Plug>AM_T,o
map <Leader>rw,  <Plug>AM_Ts,
map <Leader>r:   <Plug>AM_T:
map <Leader>r;   <Plug>AM_T;
map <Leader>r<   <Plug>AM_T<
map <Leader>r=   <Plug>AM_T=
map <Leader>r?   <Plug>AM_T?
map <Leader>r@   <Plug>AM_T@
map <Leader>rw@  <Plug>AM_TW@
map <Leader>rb   <Plug>AM_Tab
map <Leader>rp   <Plug>AM_Tsp
map <Leader>r~   <Plug>AM_T~
" character-based left-justified alignment maps
map <Leader>tb   <Plug>AM_tab
map <Leader>tl   <Plug>AM_tml
map <Leader>tp   <Plug>AM_tsp
map <Leader>tq   <Plug>AM_tsq
map <Leader>t&   <Plug>AM_tt
map <Leader>tw@  <Plug>AM_tW@
map <Leader>tw,	 <Plug>AM_ts,
map <Leader>tw:	 <Plug>AM_ts:
map <Leader>tw;	 <Plug>AM_ts;
map <Leader>tw<	 <Plug>AM_ts<
map <Leader>tw=	 <Plug>AM_ts=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VCSCommand
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let VCSCommandDisableExtensionMappings = 1
augroup VCSCommand
  au VCSCommand User VCSBufferCreated silent! nmap <unique> <buffer> q :bwipeout<cr>
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Repmo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:repmo_key = ';'
let g:repmo_revkey = "'"
let g:repmo_mapmotions = "<C-E>|<C-Y> zh|zl )|( }|{ ]]|[[ 
      \]\"|[\" ]`|[` ](|[( ])|[) ]{|[{ ]}|[} ]m|[m ]s|[s ]c|[c 
      \f|F t|T ,f|,F ,w|,b ,W|,B ,e|,me ,E|,mE ,j|,k ,n|,N"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => AmbiCompletion
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set completefunc=g:AmbiCompletion

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Sideways
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap gj :SidewaysLeft<cr>
nnoremap gk :SidewaysRight<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Powerline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:Powerline_theme            = 'benwu'
let g:Powerline_colorscheme      = 'benwu'
let g:qflist_done                = 'done, successful'
let g:Powerline_symbols_override = {
        \ 'BRANCH' : [0x2387, 0x20],
        \ 'RO'     : [0x2620],
        \ 'LINE'   : [0x2424],
        \ 'FT'     : [0x2691]
        \ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERD_Commenter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
imap <leader>cl <ESC><leader>cl

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:syntastic_enable_balloons     = 0
let g:syntastic_enable_highlighting = 1
let g:syntastic_auto_loc_list       = 1
let g:syntastic_error_symbol        = '✗'
let g:syntastic_warning_symbol      = '⚠'
let g:syntastic_async               = 1

nnoremap <silent> <leader>q :call <SID>Syntastic_Toggle()<CR>
fun! s:Syntastic_Toggle() "{{{
  if !exists("g:loaded_syntastic_plugin")
    finish
  endif

  if g:syntastic_enable == 0
    let g:syntastic_enable = 1
    echo "Syntastic Enabled!"
  elseif g:syntastic_enable == 1
    let g:syntastic_enable = 0
    if expand('%') =~? '\%(.h\|.hpp\|.hh\)$'
      if filereadable(expand('%').'.gch')
        exec "silent! !rm " . expand('%').'.gch'
        redraw!
      endif
    endif
    echo "Syntastic Disabled!"
  endif
endfunction "}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Project
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! ToggleProject() "{{{
  if !exists("g:proj_running") || bufwinnr(g:proj_running) == -1
    let file = expand("%:t")
    Project
    call search(file)
    normal zv
  else
    exec "bwipeout " . g:proj_running
  endif
endfunction "}}}
nmap <silent> <leader>x :call ToggleProject()<CR>
let g:proj_flags  = 'mstbLS'
let g:proj_igndir = "CVS, objects, obj, dict, doc"
let g:proj_filter = "*.vim *.C *.cc *.hh *.h *.py *.xml"
let g:proj_cdfile = "GNUmakefile, makefile, Makefile"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => AsyncCommand
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if( match(hostname(), 'nbay') >=0 )
  let g:asynccommand_prg = 'vim73'
endif
let g:cscope_database = "cscope.out"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => R-Plugin
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vimrplugin_screenplugin = 0
let vimrplugin_objbr_w        = 30
let vimrplugin_vimpager       = "horizontal"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Startify
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:startify_bookmarks = [ '~/.vimrc', '~/.vim/vi.elog' ]
let g:startify_custom_indices = ['a','d','f']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Clang
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:clang_hl_errors            = 1
let g:clang_snippets             = 1
let g:clang_use_library          = 1
let g:clang_snippets_engine      = 'clang_complete'
let g:clang_complete_copen       = 1
let g:clang_complete_auto        = 0
let g:clang_trailing_placeholder = 1
if( match(hostname(), 'nbay04') >=0 )
  let g:clang_library_path     = "/data/nbay04/a/benwu/BenSys/lib/"
endif
if( match(hostname(), 'Aspire') >=0 )
  let g:clang_library_path="/usr/lib/llvm-3.4/lib"
endif

" conceal in insert (i), normal (n) and visual (v) modes
set concealcursor=inv
" hide concealed text completely unless replacement character is defined
set conceallevel=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Python-Mode and Jedi
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:pymode_rope                   = 0
let g:pymode_lint_write             = 0
let g:pymode_breakpoint_key         = '<leader>tb'
let g:jedi#rename_command           = '<leader>tr'
let g:jedi#usages_command           = '<leader>tu'
let g:jedi#goto_assignments_command = '<leader>ta'
let g:jedi#goto_definitions_command = '<leader>td'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => DoxygenToolkit
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au Syntax {cpp,c,idl} runtime syntax/doxygen.vim
let g:DoxygenToolkit_commentType   = "C++"
let g:DoxygenToolkit_briefTag_post = "<++>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Gist
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gist_detect_filetype = 1
let g:gist_show_privates   = 1
let g:gist_post_private    = 1
