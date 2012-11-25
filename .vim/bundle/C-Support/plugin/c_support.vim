"#################################################################################
"
"       Filename:  c.vim
"
"    Description:  C/C++-IDE. Write programs by inserting complete statements,
"                  comments, idioms, code snippets, templates and comments.
"                  Compile, link and run one-file-programs without a makefile.
"                  See also help file csupport.txt .
"
"   GVIM Version:  7.0+
"
"  Configuration:  There are some personal details which should be configured
"                   (see the files README.csupport and csupport.txt).
"
"         Author:  Dr.-Ing. Fritz Mehner, FH Südwestfalen, 58644 Iserlohn, Germany
"          Email:  mehner@fh-swf.de
"
"        Version:  see variable  g:C_Version  below
"        Created:  04.11.2000
"        License:  Copyright (c) 2000-2011, Fritz Mehner
"                  This program is free software; you can redistribute it and/or
"                  modify it under the terms of the GNU General Public License as
"                  published by the Free Software Foundation, version 2 of the
"                  License.
"                  This program is distributed in the hope that it will be
"                  useful, but WITHOUT ANY WARRANTY; without even the implied
"                  warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
"                  PURPOSE.
"                  See the GNU General Public License version 2 for more details.
"       Revision:  $Id: c.vim,v 1.150 2011/10/14 18:10:21 mehner Exp $
"
"------------------------------------------------------------------------------
"
if v:version < 700
  echohl WarningMsg | echo 'The plugin c-support.vim needs Vim version >= 7 .'| echohl None
  finish
endif
"
" Prevent duplicate loading:
"
if exists("g:C_Version") || &cp
 finish
endif
let g:C_Version= "5.16"  							" version number of this script; do not change
"
"------------------------------------------------------------------------------
"  show / hide the c-support menus
"  define key mappings (gVim only)
"------------------------------------------------------------------------------
"
  call C#ToolMenu()
  "
  "if s:C_LoadMenus == 'yes'
    "call C#CreateGuiMenus()
  "endif
  "
  "nmap  <unique>  <silent>  <Leader>lcs   :call C#CreateGuiMenus()<CR>
  "nmap  <unique>  <silent>  <Leader>ucs   :call C#RemoveGuiMenus()<CR>
  "
"------------------------------------------------------------------------------
"  Automated header insertion
"  Local settings for the quickfix window
"
"			Vim always adds the {cmd} after existing autocommands,
"			so that the autocommands execute in the order in which
"			they were given. The order matters!
"------------------------------------------------------------------------------

if has("autocmd")
  "
  "  *.h has filetype 'cpp' by default; this can be changed to 'c' :
  "
  let s:C_TypeOfH               = 'cpp'
  call C#CheckGlobal('C_TypeOfH                ')
  if s:C_TypeOfH=='c'
    autocmd BufNewFile,BufEnter  *.h  :set filetype=c
  endif
  "
  " C/C++ source code files which should not be preprocessed.
  "
  autocmd BufNewFile,BufRead  *.i  :set filetype=c
  autocmd BufNewFile,BufRead  *.ii :set filetype=cpp
  "
  " DELAYED LOADING OF THE TEMPLATE DEFINITIONS
  "
  let s:C_TemplatesLoaded			= 'no'
  autocmd BufNewFile,BufRead  *                   
        \	if (&filetype=='cpp' || &filetype=='c') |
        \	  if s:C_TemplatesLoaded == 'no'        |
        \	  	call C#RereadTemplates('no')        |
        \	  endif |
        \ endif
  "
  "  Automated header insertion (suffixes from the gcc manual)
  "
  if !exists( 'g:C_Styles' )
    "-------------------------------------------------------------------------------
    " template styles are the default settings
    "-------------------------------------------------------------------------------
    autocmd VimEnter,BufNewFile  * if &filetype =~ '\(c\|cpp\)' && expand("%:e") !~ 'ii\?' |
          \     call C#InsertTemplateWrapper() | endif
    "
  else
    "-------------------------------------------------------------------------------
    " template styles are related to file extensions 
    "-------------------------------------------------------------------------------
    for [ pattern, stl ] in items( g:C_Styles )
      exe "autocmd BufNewFile,BufRead,BufEnter ".pattern." call C#Style( '".stl."' )"
      exe "autocmd BufNewFile                  ".pattern." call C#InsertTemplateWrapper()"
    endfor
    "
  endif
  "
  " Wrap error descriptions in the quickfix window.
  "
  autocmd BufReadPost quickfix  setlocal wrap | setlocal linebreak
  "
  let s:C_SourceCodeExtensions  = 'c cc cp cxx cpp CPP c++ C i ii'
  let s:C_SourceCodeExtensionsList	= split( s:C_SourceCodeExtensions, '\s\+' )
  exe 'autocmd BufRead *.'.join( s:C_SourceCodeExtensionsList, '\|*.' )
        \     .' call C#HighlightJumpTargets()'
  "
endif " has("autocmd")
"
"=====================================================================================
" vim: tabstop=2 shiftwidth=2 foldmethod=marker
