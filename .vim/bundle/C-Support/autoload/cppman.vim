" cppman.vim
"
" This program is free software; you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation; either version 2 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program; if not, write to the Free Software Foundation,
" Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
"
"
" Vim syntax file
" Language:	Man page
" Maintainer:	SungHyun Nam <goweol@gmail.com>
" Origianl Modified:	Wei-Ning Huang <aitjcize@gmail.com>
" Previous Maintainer:	Gautam H. Mudunuri <gmudunur@informatica.com>
" Version Info:
" Current Modified: Zhenbin Wu 

let s:old_col = &co
autocmd VimResized * call s:Rerender()
let s:stack = []
let s:sfile = resolve(expand("<sfile>:p:h"))

fun! s:InitCppMan() "{{{
  if exists("g:loaded_cppman") && g:loaded_cppman == 1
    return 
  endif
python << EOF
import vim
import os.path
import sys

if sys.version_info[:2] < (2, 5):
    raise AssertionError('Vim must be compiled with Python 2.5 or higher; you have ' + sys.version)

# get the directory this script is in: the pyflakes python module should be installed there.
scriptdir = os.path.join(os.path.dirname(vim.eval('s:sfile')), 'cppman')
print scriptdir
if scriptdir not in sys.path:
    sys.path.insert(0, scriptdir)

from cppman import cppman
cm = cppman()
EOF
  let g:loaded_cppman = 1
endfunction "}}}

fun! s:SetLocal() "{{{
  setlocal nonu
  setlocal iskeyword+=:,=,~,[,],>,*
  setlocal keywordprg=cppman
  map <buffer> q :q!<CR>
  syntax on
  syntax clear
  syntax case ignore
  syntax match  manReference       "[a-z_:+-\*][a-z_:+-~!\*<>]\+([1-9][a-z]\=)"
  syntax match  manTitle           "^\w.\+([0-9]\+[a-z]\=).*"
  syntax match  manSectionHeading  "^[a-z][a-z_ \-]*[a-z]$"
  syntax match  manSubHeading      "^\s\{3\}[a-z][a-z ]*[a-z]$"
  syntax match  manOptionDesc      "^\s*[+-][a-z0-9]\S*"
  syntax match  manLongOptionDesc  "^\s*--[a-z0-9-]\S*"

  syntax include @cppCode runtime! syntax/cpp.vim
  syntax match manCFuncDefinition  display "\<\h\w*\>\s*("me=e-1 contained

  syntax region manSynopsis start="^SYNOPSIS"hs=s+8 end="^\u\+\s*$"me=e-12 keepend contains=manSectionHeading,@cppCode,manCFuncDefinition
  syntax region manSynopsis start="^EXAMPLE"hs=s+7 end="^       [^ ]"he=s-1 keepend contains=manSectionHeading,@cppCode,manCFuncDefinition

  " Define the default highlighting.
  command -nargs=+ HiLink hi def link <args>

  HiLink manTitle           Title
  HiLink manSectionHeading  Statement
  HiLink manOptionDesc      Constant
  HiLink manLongOptionDesc  Constant
  HiLink manReference       PreProc
  HiLink manSubHeading      Function
  HiLink manCFuncDefinition Function

  delcommand HiLink

  """ Vim Viewer
  setlocal mouse=a
  setlocal colorcolumn=0

  map <buffer> K :call cppman#LoadNewPage()<CR>
  map <buffer> <CR> K
  map <buffer> <C-]> K
  map <buffer> <2-LeftMouse> K
  map <buffer> <space> <C-F>

  map <buffer> <C-T> :call cppman#BackToPrevPage()<CR>
  map <buffer> <RightMouse> <C-T>
  let b:current_syntax = "man"
endfunction "}}}

function! s:reload()
  exec "%d"
  call s:CallCppman(s:page_name)
  normal ggdd
endfunction

function s:Rerender()
  if &co != s:old_col
    let s:old_col = &co
    let save_cursor = getpos(".")
    call s:reload()
    call setpos('.', save_cursor)
  end
endfunction


function cppman#LoadNewPage()
  " Save current page to stack
  call add(s:stack, [s:page_name, getpos(".")])
  let s:page_name = expand("<cword>")
  set noro
  call s:reload()
  call search('^NAME')
  set ro
endfunction

function cppman#BackToPrevPage()
  if len(s:stack) > 0
    let context = s:stack[-1]
    set noro
    call remove(s:stack, -1)
    let s:page_name = context[0]
    call s:reload()
    call setpos('.', context[1])
    set ro
  else
    echo "No CPPMAN History"
  end
endfunction


fun! s:CallCppman(word) "{{{
python << EOF
out = cm.man(vim.eval("a:word"))
vim.command("let s:page_name = '"+ str(out['page'] +"'"))
for line in out['out'].split('\n'):
    vim.current.buffer.append(line)
EOF
endfunction "}}}

fun! cppman#FindCppman(word, mode) "{{{
  if !exists("g:loaded_cppman")
    call s:InitCppMan()
  endif

  " Use an existing "man" window if it exists, otherwise open a new one.
  if &filetype != "man"
    let thiswin = winnr()
    exe "norm! \<C-W>b"
    if winnr() > 1
      exe "norm! " . thiswin . "\<C-W>w"
      while 1
        if &filetype == "man"
          silent exec "norm 1GdG"
          break
        endif
        exe "norm! \<C-W>w"
        if thiswin == winnr()
          break
        endif
      endwhile
    endif
    if &filetype != "man"
      new
      "setl nonu fdc=0
    endif
  endif

  "" Call the cppman 
  call s:CallCppman(a:word)
  normal ggdd
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  set filetype=man
  call s:SetLocal()
  if a:mode == 0
    call search('^NAME')
  else
    call search('^EXAMPLE')
  endif
endfunction "}}}

function cppman#CppManAskForWord() "{{{
    let l:strng = input("What to lookup: ")
    call cppman#FindCppman(l:strng, "")
endfunction "}}}
