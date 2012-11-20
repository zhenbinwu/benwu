" ------------------------------------------------------------------------------
"
" Vim filetype plugin file (part of the c.vim plugin)
"
"   Language :  make 
"     Plugin :  c.vim 
" Maintainer :  Fritz Mehner <mehner@fh-swf.de>
"   Revision :  $Id: make.vim,v 1.3 2011/04/12 09:00:32 mehner Exp $
"
" ------------------------------------------------------------------------------
"
" Only do this when not done yet for this buffer
" 
if exists("b:did_make_ftplugin")
  finish
endif
let b:did_make_ftplugin = 1

 map    <buffer>  <silent>  <LocalLeader>rm         :call C#Make()<CR>
imap    <buffer>  <silent>  <LocalLeader>rm    <C-C>:call C#Make()<CR>
 map    <buffer>  <silent>  <LocalLeader>rmc        :call C#MakeClean()<CR>
imap    <buffer>  <silent>  <LocalLeader>rmc   <C-C>:call C#MakeClean()<CR>
 map    <buffer>  <silent>  <LocalLeader>rme        :call C#MakeExeToRun()<CR>
imap    <buffer>  <silent>  <LocalLeader>rme   <C-C>:call C#MakeExeToRun()<CR>
 map    <buffer>  <silent>  <LocalLeader>rma        :call C#MakeArguments()<CR>
imap    <buffer>  <silent>  <LocalLeader>rma   <C-C>:call C#MakeArguments()<CR>

