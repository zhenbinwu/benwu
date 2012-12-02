" ------------------------------------------------------------------------------
"
" Vim filetype plugin file
"
"   Language :  C / C++
"     Plugin :  c.vim 
" Maintainer :  Fritz Mehner <mehner@fh-swf.de>
"   Revision :  $Id: c.vim,v 1.69 2011/08/28 15:46:38 mehner Exp $
"
" ------------------------------------------------------------------------------
"
" Only do this when not done yet for this buffer
" 
if exists("b:did_C_ftplugin")
  finish
endif
let b:did_C_ftplugin = 1
"
" ---------- system installation or local installation ----------
"
let s:installation				= 'local'
if match( expand("<sfile>"), escape( $VIM, ' \' ) ) == 0
	let s:installation						= 'system'
endif
"
" ---------- Do we have a mapleader other than '\' ? ------------
"
if exists("g:C_MapLeader")
  let maplocalleader  = g:C_MapLeader
endif    
"
" ---------- C/C++ dictionary -----------------------------------
" This will enable keyword completion for C and C++
" using Vim's dictionary feature |i_CTRL-X_CTRL-K|.
" Set the new dictionaries in front of the existing ones
" 
if exists("g:C_Dictionary_File")
  let save=&dictionary
  silent! exe 'setlocal dictionary='.g:C_Dictionary_File
  silent! exe 'setlocal dictionary+='.save
endif    
"
" ---------- F-key mappings  ------------------------------------
"
"   Alt-F9   write buffer and compile
"       F9   compile and link
"  Ctrl-F9   run executable
" Shift-F9   command line arguments
"
" map  <buffer>  <silent>  <A-F9>       :call C#Compile()<CR>:call C#HlMessage()<CR>
"imap  <buffer>  <silent>  <A-F9>  <C-C>:call C#Compile()<CR>:call C#HlMessage()<CR>
"
" map  <buffer>  <silent>    <F9>       :call C#Link()<CR>:call C#HlMessage()<CR>
"imap  <buffer>  <silent>    <F9>  <C-C>:call C#Link()<CR>:call C#HlMessage()<CR>
""
" map  <buffer>  <silent>  <C-F9>       :call C#Run()<CR>
"imap  <buffer>  <silent>  <C-F9>  <C-C>:call C#Run()<CR>
"
" map  <buffer>  <silent>  <S-F9>       :call C#Arguments()<CR>
"imap  <buffer>  <silent>  <S-F9>  <C-C>:call C#Arguments()<CR>
"
" ---------- alternate file plugin (a.vim) ----------------------
"
if exists("loaded_alternateFile")
  map  <buffer>  <silent>  <S-F2>       :A<CR>
  imap  <buffer>  <silent>  <S-F2>  <C-C>:A<CR>
endif
"
command! -nargs=1 -complete=customlist,C#CFileSectionList        CFileSection       call C#CFileSectionListInsert   (<f-args>)
command! -nargs=1 -complete=customlist,C#HFileSectionList        HFileSection       call C#HFileSectionListInsert   (<f-args>)
command! -nargs=1 -complete=customlist,C#KeywordCommentList      KeywordComment     call C#KeywordCommentListInsert (<f-args>)
command! -nargs=1 -complete=customlist,C#SpecialCommentList      SpecialComment     call C#SpecialCommentListInsert (<f-args>)
command! -nargs=1 -complete=customlist,C#StdLibraryIncludesList  IncludeStdLibrary  call C#StdLibraryIncludesInsert (<f-args>)
command! -nargs=1 -complete=customlist,C#C99LibraryIncludesList  IncludeC99Library  call C#C99LibraryIncludesInsert (<f-args>)
command! -nargs=1 -complete=customlist,C#CppLibraryIncludesList  IncludeCppLibrary  call C#CppLibraryIncludesInsert (<f-args>)
command! -nargs=1 -complete=customlist,C#CppCLibraryIncludesList IncludeCppCLibrary call C#CppCLibraryIncludesInsert(<f-args>)
command! -nargs=1 -complete=customlist,C#StyleList               CStyle             call C#Style                    (<f-args>)

" ---------- KEY MAPPINGS : MENU ENTRIES -------------------------------------
" ---------- comments menu  ------------------------------------------------
"
" noremap    <buffer>  <silent>  <LocalLeader>cl         :call C#LineEndComment()<CR>
"inoremap    <buffer>  <silent>  <LocalLeader>cl    <Esc>:call C#LineEndComment()<CR>
"vnoremap    <buffer>  <silent>  <LocalLeader>cl    <Esc>:call C#MultiLineEndComments()<CR>a
"
nnoremap    <buffer>  <silent>  <LocalLeader>cj         :call C#AdjustLineEndComm()<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>cj         :call C#AdjustLineEndComm()<CR>
inoremap    <buffer>  <silent>  <LocalLeader>cj    <Esc>:call CBrowseTemplateFiles#AdjustLineEndComm()<CR>a
"
 noremap    <buffer>  <silent>  <LocalLeader>cs         :call C#GetLineEndCommCol()<CR>

 noremap    <buffer>  <silent>  <LocalLeader>c*         :call C#CodeToCommentC()<CR>:nohlsearch<CR>j
vnoremap    <buffer>  <silent>  <LocalLeader>c*         :call C#CodeToCommentC()<CR>:nohlsearch<CR>j

 "noremap    <buffer>  <silent>  <LocalLeader>cc         :call C#CodeToCommentCpp()<CR>:nohlsearch<CR>j
"vnoremap    <buffer>  <silent>  <LocalLeader>cc    <Esc>:call C#CodeToCommentCpp()<CR>:nohlsearch<CR>j
 "noremap    <buffer>  <silent>  <LocalLeader>co         :call C#CommentToCode()<CR>:nohlsearch<CR>
"vnoremap    <buffer>  <silent>  <LocalLeader>co    <Esc>:call C#CommentToCode()<CR>:nohlsearch<CR>

noremap    <buffer>  <silent>  <LocalLeader>cfr        :call C#InsertTemplateNoIndent("comment.frame")<CR>
noremap    <buffer>  <silent>  <LocalLeader>cu        :call C#InsertTemplateNoIndent("comment.function")<CR>
noremap    <buffer>  <silent>  <LocalLeader>cm        :call C#InsertTemplateNoIndent("comment.method")<CR>
noremap    <buffer>  <silent>  <LocalLeader>cs        :call C#InsertTemplateNoIndent("comment.class")<CR>
"noremap    <buffer>  <silent>  <LocalLeader>cfdi       :call C#InsertTemplateNoIndent("comment.file-description")<CR>
"noremap    <buffer>  <silent>  <LocalLeader>cfdh       :call C#InsertTemplateNoIndent("comment.file-description-header")<CR>

inoremap    <buffer>  <silent>  <LocalLeader>cfr   <Esc>:call C#InsertTemplateNoIndent("comment.frame")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>cu   <Esc>:call C#InsertTemplateNoIndent("comment.function")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>cm   <Esc>:call C#InsertTemplateNoIndent("comment.method")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>cs   <Esc>:call C#InsertTemplateNoIndent("comment.class")<CR>
"inoremap    <buffer>  <silent>  <LocalLeader>cfdi  <Esc>:call C#InsertTemplateNoIndent("comment.file-description")<CR>
"inoremap    <buffer>  <silent>  <LocalLeader>cfdh  <Esc>:call C#InsertTemplateNoIndent("comment.file-description-header")<CR>

" noremap    <buffer>  <silent>  <LocalLeader>cd    <Esc>:call C#InsertDateAndTime('d')<CR>
inoremap    <buffer>  <silent>  <LocalLeader>cd    <Esc>:call C#InsertDateAndTime('d')<CR>a
vnoremap    <buffer>  <silent>  <LocalLeader>cd   s<Esc>:call C#InsertDateAndTime('d')<CR>a
 noremap    <buffer>  <silent>  <LocalLeader>ct    <Esc>:call C#InsertDateAndTime('dt')<CR>
inoremap    <buffer>  <silent>  <LocalLeader>ct    <Esc>:call C#InsertDateAndTime('dt')<CR>a
vnoremap    <buffer>  <silent>  <LocalLeader>ct   s<Esc>:call C#InsertDateAndTime('dt')<CR>a
" 
 "noremap    <buffer>  <silent>  <LocalLeader>cx         :call C#CommentToggle( )<CR>
"inoremap    <buffer>  <silent>  <LocalLeader>cx    <Esc>:call C#CommentToggle( )<CR>
"vnoremap    <buffer>  <silent>  <LocalLeader>cx         :call C#CommentToggle( )<CR>
"
" call the above defined commands:
"
 noremap    <buffer>            <LocalLeader>ce   <Esc>:CFileSection<Space>
 noremap    <buffer>            <LocalLeader>ch   <Esc>:HFileSection<Space>
 noremap    <buffer>            <LocalLeader>ck   <Esc>:KeywordComment<Space>
 noremap    <buffer>            <LocalLeader>cx   <Esc>:SpecialComment<Space>
"
inoremap    <buffer>            <LocalLeader>ce   <Esc>:CFileSection<Space>
inoremap    <buffer>            <LocalLeader>ch   <Esc>:HFileSection<Space>
inoremap    <buffer>            <LocalLeader>ck   <Esc>:KeywordComment<Space>
inoremap    <buffer>            <LocalLeader>cx   <Esc>:SpecialComment<Space>
" 
" ---------- statements menu  ------------------------------------------------
"
 noremap    <buffer>  <silent>  <LocalLeader>sd         :call C#InsertTemplate("statements.do-while")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>sd    <Esc>:call C#InsertTemplate("statements.do-while", "v")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>sd    <Esc>:call C#InsertTemplate("statements.do-while")<CR>

 "noremap    <buffer>  <silent>  <LocalLeader>sf         :call C#InsertTemplate("statements.for")<CR>
"inoremap    <buffer>  <silent>  <LocalLeader>sf    <Esc>:call C#InsertTemplate("statements.for")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>sf        :call C#InsertTemplate("statements.for-block")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>sf   <Esc>:call C#InsertTemplate("statements.for-block", "v")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>sf   <Esc>:call C#InsertTemplate("statements.for-block")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>si         :call C#InsertTemplate("statements.if")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>si    <Esc>:call C#InsertTemplate("statements.if")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>sj        :call C#InsertTemplate("statements.if-block")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>sj   <Esc>:call C#InsertTemplate("statements.if-block", "v")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>sj   <Esc>:call C#InsertTemplate("statements.if-block")<CR>

 "noremap    <buffer>  <silent>  <LocalLeader>sie        :call C#InsertTemplate("statements.if-else")<CR>
"vnoremap    <buffer>  <silent>  <LocalLeader>sie   <Esc>:call C#InsertTemplate("statements.if-else", "v")<CR>
"inoremap    <buffer>  <silent>  <LocalLeader>sie   <Esc>:call C#InsertTemplate("statements.if-else")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>sk       :call C#InsertTemplate("statements.if-block-else")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>sk  <Esc>:call C#InsertTemplate("statements.if-block-else", "v")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>sk  <Esc>:call C#InsertTemplate("statements.if-block-else")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>se         :call C#InsertTemplate("statements.else-block")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>se    <Esc>:call C#InsertTemplate("statements.else-block", "v")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>se    <Esc>:call C#InsertTemplate("statements.else-block")<CR>

 "noremap    <buffer>  <silent>  <LocalLeader>sw         :call C#InsertTemplate("statements.while")<CR>
"inoremap    <buffer>  <silent>  <LocalLeader>sw    <Esc>:call C#InsertTemplate("statements.while")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>sw        :call C#InsertTemplate("statements.while-block")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>sw   <Esc>:call C#InsertTemplate("statements.while-block", "v")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>sw   <Esc>:call C#InsertTemplate("statements.while-block")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>ss         :call C#InsertTemplate("statements.switch")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>ss    <Esc>:call C#InsertTemplate("statements.switch", "v")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>ss    <Esc>:call C#InsertTemplate("statements.switch")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>sc         :call C#InsertTemplate("statements.case")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>sc    <Esc>:call C#InsertTemplate("statements.case")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>s{         :call C#InsertTemplate("statements.block")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>s{    <Esc>:call C#InsertTemplate("statements.block", "v")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>s{    <Esc>:call C#InsertTemplate("statements.block")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>sb         :call C#InsertTemplate("statements.block")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>sb    <Esc>:call C#InsertTemplate("statements.block", "v")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>sb    <Esc>:call C#InsertTemplate("statements.block")<CR>
"
" ---------- preprocessor menu  ----------------------------------------------
"
 noremap    <buffer>  <LocalLeader>ps                  :IncludeStdLibrary<Space>
inoremap    <buffer>  <LocalLeader>ps             <Esc>:IncludeStdLibrary<Space>
 noremap    <buffer>  <LocalLeader>pc                  :IncludeC99Library<Space>
inoremap    <buffer>  <LocalLeader>pc             <Esc>:IncludeC99Library<Space>
 noremap    <buffer>  <LocalLeader>ts                 :IncludeCppLibrary<Space>
inoremap    <buffer>  <LocalLeader>ts            <Esc>:IncludeCppLibrary<Space>
 noremap    <buffer>  <LocalLeader>tc                 :IncludeCppCLibrary<Space>
inoremap    <buffer>  <LocalLeader>tc            <Esc>:IncludeCppC9Library<Space>
"
 noremap    <buffer>  <silent>  <LocalLeader>pg        :call C#InsertTemplate("preprocessor.include-global")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>pi        :call C#InsertTemplate("preprocessor.include-local")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>pd        :call C#InsertTemplate("preprocessor.define")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>pu        :call C#InsertTemplate("preprocessor.undefine")<CR>
"
inoremap    <buffer>  <silent>  <LocalLeader>pg   <Esc>:call C#InsertTemplate("preprocessor.include-global")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>pi   <Esc>:call C#InsertTemplate("preprocessor.include-local")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>pd   <Esc>:call C#InsertTemplate("preprocessor.define")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>pu   <Esc>:call C#InsertTemplate("preprocessor.undefine")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>pf       :call C#InsertTemplate("preprocessor.if-else-endif")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>pa       :call C#InsertTemplate("preprocessor.ifdef-else-endif")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>pk       :call C#InsertTemplate("preprocessor.ifndef-else-endif")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>pj      :call C#InsertTemplate("preprocessor.ifndef-def-endif")<CR>

vnoremap    <buffer>  <silent>  <LocalLeader>pf  <Esc>:call C#InsertTemplate("preprocessor.if-else-endif", "v")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>pa  <Esc>:call C#InsertTemplate("preprocessor.ifdef-else-endif", "v")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>pk  <Esc>:call C#InsertTemplate("preprocessor.ifndef-else-endif", "v")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>pj <Esc>:call C#InsertTemplate("preprocessor.ifndef-def-endif", "v")<CR>
                                     
inoremap    <buffer>  <silent>  <LocalLeader>pf  <Esc>:call C#InsertTemplate("preprocessor.if-else-endif")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>pa  <Esc>:call C#InsertTemplate("preprocessor.ifdef-else-endif")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>pk  <Esc>:call C#InsertTemplate("preprocessor.ifndef-else-endif")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>pj <Esc>:call C#InsertTemplate("preprocessor.ifndef-def-endif")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>p0       :call C#PPIf0("a")<CR>2ji
inoremap    <buffer>  <silent>  <LocalLeader>p0  <Esc>:call C#PPIf0("a")<CR>2ji
vnoremap    <buffer>  <silent>  <LocalLeader>p0  <Esc>:call C#PPIf0("v")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>pr       :call C#PPIf0Remove()<CR>
inoremap    <buffer>  <silent>  <LocalLeader>pr  <Esc>:call C#PPIf0Remove()<CR>
"
 noremap    <buffer>  <silent>  <LocalLeader>pe        :call C#InsertTemplate("preprocessor.error")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>pl        :call C#InsertTemplate("preprocessor.line")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>pp        :call C#InsertTemplate("preprocessor.pragma")<CR>
"
inoremap    <buffer>  <silent>  <LocalLeader>pe   <Esc>:call C#InsertTemplate("preprocessor.error")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>pl   <Esc>:call C#InsertTemplate("preprocessor.line")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>pp   <Esc>:call C#InsertTemplate("preprocessor.pragma")<CR>
"
" ---------- idioms menu  ----------------------------------------------------
"
 "noremap    <buffer>  <silent>  <LocalLeader>if         :call C#InsertTemplate("idioms.function")<CR>
"vnoremap    <buffer>  <silent>  <LocalLeader>if    <Esc>:call C#InsertTemplate("idioms.function", "v")<CR>
"inoremap    <buffer>  <silent>  <LocalLeader>if    <Esc>:call C#InsertTemplate("idioms.function")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>if        :call C#InsertTemplate("idioms.function-static")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>if   <Esc>:call C#InsertTemplate("idioms.function-static", "v")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>if   <Esc>:call C#InsertTemplate("idioms.function-static")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>im         :call C#InsertTemplate("idioms.main")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>im    <Esc>:call C#InsertTemplate("idioms.main", "v")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>im    <Esc>:call C#InsertTemplate("idioms.main")<CR>
"
 noremap    <buffer>  <silent>  <LocalLeader>iu         :call C#CodeFor("up"  )<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>iu         :call C#CodeFor("up"  )<CR>
inoremap    <buffer>  <silent>  <LocalLeader>iu    <Esc>:call C#CodeFor("up"  )<CR>i
 noremap    <buffer>  <silent>  <LocalLeader>id         :call C#CodeFor("down")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>id         :call C#CodeFor("down")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>id    <Esc>:call C#CodeFor("down")<CR>i
"
 noremap    <buffer>  <silent>  <LocalLeader>ie         :call C#InsertTemplate("idioms.enum")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>ie    <Esc>:call C#InsertTemplate("idioms.enum"  , "v")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>ie    <Esc>:call C#InsertTemplate("idioms.enum")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>is         :call C#InsertTemplate("idioms.struct")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>is    <Esc>:call C#InsertTemplate("idioms.struct", "v")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>is    <Esc>:call C#InsertTemplate("idioms.struct")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>iu         :call C#InsertTemplate("idioms.union")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>iu    <Esc>:call C#InsertTemplate("idioms.union" , "v")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>iu    <Esc>:call C#InsertTemplate("idioms.union")<CR>
"
 noremap    <buffer>  <silent>  <LocalLeader>ip         :call C#InsertTemplate("idioms.printf")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>ip    <Esc>:call C#InsertTemplate("idioms.printf")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>ic        :call C#InsertTemplate("idioms.scanf")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>ic   <Esc>:call C#InsertTemplate("idioms.scanf")<CR>
"
 noremap    <buffer>  <silent>  <LocalLeader>ik        :call C#InsertTemplate("idioms.calloc")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>ik   <Esc>:call C#InsertTemplate("idioms.calloc")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>ij       :call C#InsertTemplate("idioms.malloc")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>ij  <Esc>:call C#InsertTemplate("idioms.malloc")<CR>
"
 noremap    <buffer>  <silent>  <LocalLeader>iz        :call C#InsertTemplate("idioms.sizeof")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>iz   <Esc>:call C#InsertTemplate("idioms.sizeof")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>iz   <Esc>:call C#InsertTemplate("idioms.sizeof", "v")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>ia        :call C#InsertTemplate("idioms.assert")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>ia   <Esc>:call C#InsertTemplate("idioms.assert", "v")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>ia   <Esc>:call C#InsertTemplate("idioms.assert")<CR>
"
 noremap    <buffer>  <silent>  <LocalLeader>ii         :call C#InsertTemplate("idioms.open-input-file")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>ii    <Esc>:call C#InsertTemplate("idioms.open-input-file")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>ii    <Esc>:call C#InsertTemplate("idioms.open-input-file", "v")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>io         :call C#InsertTemplate("idioms.open-output-file")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>io    <Esc>:call C#InsertTemplate("idioms.open-output-file")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>io    <Esc>:call C#InsertTemplate("idioms.open-output-file", "v")<CR>
"
" ---------- snippet menu : snippets -----------------------------------------
"
 noremap    <buffer>  <silent>  <LocalLeader>mr         :call C#CodeSnippet("r")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>mw         :call C#CodeSnippet("w")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>mw    <Esc>:call C#CodeSnippet("wv")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>me         :call C#CodeSnippet("e")<CR>
"
inoremap    <buffer>  <silent>  <LocalLeader>mr    <Esc>:call C#CodeSnippet("r")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>mw    <Esc>:call C#CodeSnippet("w")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>me    <Esc>:call C#CodeSnippet("e")<CR>
"
" ---------- snippet menu : prototypes ---------------------------------------
"
 noremap    <buffer>  <silent>  <LocalLeader>mf        :call C#ProtoPick("function")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>mf        :call C#ProtoPick("function")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>mf   <Esc>:call C#ProtoPick("function")<CR>
"
 noremap    <buffer>  <silent>  <LocalLeader>md        :call C#ProtoPick("method")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>md        :call C#ProtoPick("method")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>md   <Esc>:call C#ProtoPick("method")<CR>
"
 noremap    <buffer>  <silent>  <LocalLeader>mi         :call C#ProtoInsert()<CR>
inoremap    <buffer>  <silent>  <LocalLeader>mi    <Esc>:call C#ProtoInsert()<CR>
"
 noremap    <buffer>  <silent>  <LocalLeader>mc         :call C#ProtoClear()<CR>
inoremap    <buffer>  <silent>  <LocalLeader>mc    <Esc>:call C#ProtoClear()<CR>
"
 noremap    <buffer>  <silent>  <LocalLeader>ms         :call C#ProtoShow()<CR>
inoremap    <buffer>  <silent>  <LocalLeader>ms    <Esc>:call C#ProtoShow()<CR>
"
" ---------- snippet menu : templates ----------------------------------------
"
 noremap    <buffer>  <silent>  <LocalLeader>ml        :call C#BrowseTemplateFiles("Local")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>ml   <Esc>:call C#BrowseTemplateFiles("Local")<CR>
 if s:installation == 'system'
	 noremap    <buffer>  <silent>  <LocalLeader>mg        :call C#BrowseTemplateFiles("Global")<CR>
	inoremap    <buffer>  <silent>  <LocalLeader>mg   <Esc>:call C#BrowseTemplateFiles("Global")<CR>
 endif
 noremap    <buffer>  <silent>  <LocalLeader>mp        :call C#RereadTemplates()<CR>
 noremap    <buffer>            <LocalLeader>my        :CStyle<Space>
inoremap    <buffer>  <silent>  <LocalLeader>mp   <Esc>:call C#RereadTemplates()<CR>
inoremap    <buffer>            <LocalLeader>my   <Esc>:CStyle<Space>
"
" ---------- C++ menu ----------------------------------------------------
"
 noremap    <buffer>  <silent>  <LocalLeader>ti         :call C#InsertTemplate("cpp.cout-operator")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>ti    <Esc>:call C#InsertTemplate("cpp.cout-operator")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>to        :call C#InsertTemplate("cpp.cout")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>to   <Esc>:call C#InsertTemplate("cpp.cout")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>td        :call C#InsertTemplate("cpp.debug")<CR><ESC>
inoremap    <buffer>  <silent>  <LocalLeader>td   <Esc>:call C#InsertTemplate("cpp.debug")<CR>
"
 noremap    <buffer>  <silent>  <LocalLeader>tg        :call C#InsertTemplate("cpp.class-definition")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>tg   <Esc>:call C#InsertTemplate("cpp.class-definition")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>th        :call C#InsertTemplate("cpp.class-using-new-definition")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>th   <Esc>:call C#InsertTemplate("cpp.class-using-new-definition")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>tG        :call C#InsertTemplate("cpp.class-implementation")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>tG   <Esc>:call C#InsertTemplate("cpp.class-implementation")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>tH       :call C#InsertTemplate("cpp.class-using-new-implementation")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>tH  <Esc>:call C#InsertTemplate("cpp.class-using-new-implementation")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>ty        :call C#InsertTemplate("cpp.method-implementation")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>ty   <Esc>:call C#InsertTemplate("cpp.method-implementation")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>tu        :call C#InsertTemplate("cpp.accessor-implementation")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>tu  <Esc>:call C#InsertTemplate("cpp.accessor-implementation")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>tj        :call C#InsertTemplate("cpp.template-class-definition")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>tj   <Esc>:call C#InsertTemplate("cpp.template-class-definition")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>tk       :call C#InsertTemplate("cpp.template-class-using-new-definition")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>tk  <Esc>:call C#InsertTemplate("cpp.template-class-using-new-definition")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>tJ       :call C#InsertTemplate("cpp.template-class-implementation")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>tJ  <Esc>:call C#InsertTemplate("cpp.template-class-implementation")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>tK      :call C#InsertTemplate("cpp.template-class-using-new-implementation")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>tK <Esc>:call C#InsertTemplate("cpp.template-class-using-new-implementation")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>tx       :call C#InsertTemplate("cpp.template-method-implementation")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>tx  <Esc>:call C#InsertTemplate("cpp.template-method-implementation")<CR>
 noremap    <buffer>  <silent>  <LocalLeader>ta       :call C#InsertTemplate("cpp.template-accessor-implementation")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>ta  <Esc>:call C#InsertTemplate("cpp.template-accessor-implementation")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>tf        :call C#InsertTemplate("cpp.template-function")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>tf   <Esc>:call C#InsertTemplate("cpp.template-function")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>tv        :call C#InsertTemplate("cpp.error-class")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>tv   <Esc>:call C#InsertTemplate("cpp.error-class")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>tr        :call C#InsertTemplate("cpp.try-catch")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>tr   <Esc>:call C#InsertTemplate("cpp.try-catch", "v")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>tr   <Esc>:call C#InsertTemplate("cpp.try-catch")<CR>

 "noremap    <buffer>  <silent>  <LocalLeader>ca        :call C#InsertTemplate("cpp.catch")<CR>
"vnoremap    <buffer>  <silent>  <LocalLeader>ca   <Esc>:call C#InsertTemplate("cpp.catch", "v")<CR>
"inoremap    <buffer>  <silent>  <LocalLeader>ca   <Esc>:call C#InsertTemplate("cpp.catch")<CR>

 noremap    <buffer>  <silent>  <LocalLeader>c.        :call C#InsertTemplate("cpp.catch-points")<CR>
vnoremap    <buffer>  <silent>  <LocalLeader>c.   <Esc>:call C#InsertTemplate("cpp.catch-points", "v")<CR>
inoremap    <buffer>  <silent>  <LocalLeader>c.   <Esc>:call C#InsertTemplate("cpp.catch-points")<CR>
"
" ---------- run menu --------------------------------------------------------
"
 map    <buffer>  <silent>  <LocalLeader>rc         :call C#Compile()<CR>:call C#HlMessage()<CR>
 map    <buffer>  <silent>  <LocalLeader>rl         :call C#Link()<CR>:call C#HlMessage()<CR>
 map    <buffer>  <silent>  <LocalLeader>rf         :call C#Run()<CR>
 map    <buffer>  <silent>  <LocalLeader>ra         :call C#Arguments()<CR>
 map    <buffer>  <silent>  <LocalLeader>rm         :call C#Make()<CR>
 map    <buffer>  <silent>  <LocalLeader>rn        :call C#MakeClean()<CR>
 map    <buffer>  <silent>  <LocalLeader>re        :call C#MakeExeToRun()<CR>
 map    <buffer>  <silent>  <LocalLeader>rg         :call C#MakeArguments()<CR>
 if executable("splint") 
   map    <buffer>  <silent>  <LocalLeader>rq         :call C#SplintCheck()<CR>:call C#HlMessage()<CR>
   map    <buffer>  <silent>  <LocalLeader>ri         :call C#SplintArguments()<CR>
 endif
 map    <buffer>  <silent>  <LocalLeader>rd         :call C#Indent()<CR>
 map    <buffer>  <silent>  <LocalLeader>rh         :call C#Hardcopy()<CR>
 map    <buffer>  <silent>  <LocalLeader>rs         :call C#Settings()<CR>
"
vmap    <buffer>  <silent>  <LocalLeader>rh         :call C#Hardcopy()<CR>
"
imap    <buffer>  <silent>  <LocalLeader>rc    <C-C>:call C#Compile()<CR>:call C#HlMessage()<CR>
imap    <buffer>  <silent>  <LocalLeader>rl    <C-C>:call C#Link()<CR>:call C#HlMessage()<CR>
imap    <buffer>  <silent>  <LocalLeader>rf    <C-C>:call C#Run()<CR>
imap    <buffer>  <silent>  <LocalLeader>ra    <C-C>:call C#Arguments()<CR>
imap    <buffer>  <silent>  <LocalLeader>rm    <C-C>:call C#Make()<CR>
imap    <buffer>  <silent>  <LocalLeader>rn   <C-C>:call C#MakeClean()<CR>
imap    <buffer>  <silent>  <LocalLeader>re   <C-C>:call C#MakeExeToRun()<CR>
imap    <buffer>  <silent>  <LocalLeader>rg    <C-C>:call C#MakeArguments()<CR>
if executable("splint") 
  imap    <buffer>  <silent>  <LocalLeader>rq    <C-C>:call C#SplintCheck()<CR>:call C#HlMessage()<CR>
  imap    <buffer>  <silent>  <LocalLeader>ri    <C-C>:call C#SplintArguments()<CR>
endif
imap    <buffer>  <silent>  <LocalLeader>rd    <C-C>:call C#Indent()<CR>
imap    <buffer>  <silent>  <LocalLeader>rh    <C-C>:call C#Hardcopy()<CR>
imap    <buffer>  <silent>  <LocalLeader>rs    <C-C>:call C#Settings()<CR>
if has("unix")
  map    <buffer>  <silent>  <LocalLeader>rx         :call C#XtermSize()<CR>
  imap    <buffer>  <silent>  <LocalLeader>rx    <C-C>:call C#XtermSize()<CR>
endif
 map    <buffer>  <silent>  <LocalLeader>ro         :call C#Toggle_Gvim_Xterm()<CR>
imap    <buffer>  <silent>  <LocalLeader>ro    <C-C>:call C#Toggle_Gvim_Xterm()<CR>
"
" Abraxas CodeCheck (R)
"
if executable("check") 
  map    <buffer>  <silent>  <LocalLeader>rk         :call C#CodeCheck()<CR>:call C#HlMessage()<CR>
  map    <buffer>  <silent>  <LocalLeader>re         :call C#CodeCheckArguments()<CR>
 imap    <buffer>  <silent>  <LocalLeader>rk    <C-C>:call C#CodeCheck()<CR>:call C#HlMessage()<CR>
 imap    <buffer>  <silent>  <LocalLeader>re    <C-C>:call C#CodeCheckArguments()<CR>
endif
" ---------- plugin help -----------------------------------------------------
"
 map    <buffer>  <silent>  <LocalLeader>hp         :call C#HelpCsupport()<CR>
imap    <buffer>  <silent>  <LocalLeader>hp    <C-C>:call C#HelpCsupport()<CR>
 map    <buffer>  <silent>  <LocalLeader>hm         :call C#Help("m")<CR>
imap    <buffer>  <silent>  <LocalLeader>hm    <C-C>:call C#Help("m")<CR>
"
"-------------------------------------------------------------------------------
" additional mapping : complete a classical C comment: '/*' => '/* | */'
"-------------------------------------------------------------------------------
inoremap  <buffer>  /*       /*<Space><Space>*/<Left><Left><Left>
vnoremap  <buffer>  /*      s/*<Space><Space>*/<Left><Left><Left><Esc>p
"
"-------------------------------------------------------------------------------
" additional mapping : complete a classical C multi-line comment: 
"                      '/*<CR>' =>  /*
"                                    * |
"                                    */
"-------------------------------------------------------------------------------
inoremap  <buffer>  /*<CR>  /*<CR><CR>/<Esc>kA<Space>
"
"-------------------------------------------------------------------------------
" additional mapping : {<CR> always opens a block
"-------------------------------------------------------------------------------
inoremap  <buffer>  {<CR>    {<CR>}<Esc>O
vnoremap  <buffer>  {<CR>   S{<CR>}<Esc>Pk=iB
"
"
if !exists("g:C_Ctrl_j") || ( exists("g:C_Ctrl_j") && g:C_Ctrl_j != 'off' )
  ""nmap    <buffer>  <silent>  <C-j>    <C-R>=C#JumpCtrlJ()<CR>
  imap    <buffer>  <silent>  <C-j>    <C-R>=C#JumpCtrlJ()<CR>
endif
