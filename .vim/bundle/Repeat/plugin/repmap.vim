" Vim plugin -- repeat motions for which a count was given
" General: {{{1
" File:         repmo.vim
" Created:      2008 Jan 27
" Last Change:  2009 Jun 03
" Rev Days:     7
" Author:	Andy Wokula <anwoku@yahoo.de>
" Editor:       Ben Wu <benwu@fnal.gov> (I made some significant changes to
" this script so that it could work with user defined mapping. )
" Version:	0.5

" Question: BML schrieb: Is there a way/command to repeat the last movement,
"   like ; and , repeat the last f command? It would be nice to be able to
"   select the 'scrolling' speed by typing 5j or 8j, and then simply hold
"   down a key and what the text scroll by at your given speed. Ben
" Answer: No there isn't, but an exception is  :h 'scroll
"   Or take repmo.vim as an answer.  It overloads the keys ";" and "," to
"   repeat motions.

" Usage By Example:
"   Type "5j" and then ";" to repeat "5j" (after  :RepmoMap j k ).
"   Type "hjkl" and then ";", it still repeats "5j".
"   Type "," to do "5k" (go in reverse direction).
"   Type "4k" and then ";" to repeat "4k" (after  :RepmoMap k j ).
"
"   The following motions (and scroll commands) are mapped per default:
"	j,k, h,l, Ctrl-E,Ctrl-Y, zh,zl
"
" Compatibility:
" - Visual mode
" - "f{char}" followed by ";,"
" - Operator pending mode with ";" and ","

" Commands:
"   :RepmoMap {motion}|{reverse-motion} ... [<unique>] ...
"
"	Map {motion} to be repeatable with ";".  Use {reverse-motion} for
"	",".  Key notation is like in mappings.
"	If one of the arguments is <unique>, all key pairs right from it are
"	mapped with <unique> modifier (:h map-<unique>).

" Options:		    type	default	    when checked
"   g:repmo_key		    (string)	";"	    frequently, e.g. when
"   g:repmo_revkey	    (string)	","	      \ doing "5j"
"   g:repmo_mapmotions	    (bool)	1	    when sourced
"
" see Customization for details

" Installation:
"   it's a plugin, simply :source it (e.g. :so %)

" Hints:
" - there is little error checking, don't do  :let repmo_key = " " or "|"
"   etc.
" - to unmap "f", "F", "t", "T", ";" and "," at once, simply type "ff" (for
"   example); the next "5j" maps them again
" - to avoid mapping "f", "F", "t" and "T" at all, use other keys than ";"
"   and "," for repeating
" - Debugging:  :debug normal 5j  doesn't work, use  5:<C-U>debug normal j
"   instead; but  5:<C-U>normal jjj  does  5j5j5j
" - when changing g:repmo_key, g:repmo_revkey during session, the old keys
"   will not be unmapped automatically

" TODO:
" - more\test\C130.vim
" ? preserve remappings by user, e.g. :map j gj
"   currently these mappings are replaced without warning
" ? [count]{g:repmo_key} -- multiply the counts?
" - protect more alien :omaps (yankring!)
" + make ";" and "," again work with "f{char}", "F{char}", ...
" + v0.2 don't touch user's mappings for f/F/t/T
" + v0.2 check for empty g:repmo_key
" + check key notation: '\|' is ok, '|' not ok
"   no check added: we cannot check for everything
" + Bug: i_<C-O>l inserts rest of l-mapping in the text; for l and h
"   VimBuddy doesn't rotate its nose ... ah, statusline is updated twice
"   ! v0.3 use  :normal {motion}  within the function
" v0.5
" + :RepmoMap, new argument syntax
" + work in Vi-mode with <special>
" + added :sil! before  unmap ;  in case user unmapped ";" by hand
" + :normal didn't work with <Space> (i.e. " ")
" + let f/F/t/T accept a count when unmapping

" }}}

" Script Init Folklore: {{{1
if exists("loaded_repmo")
    finish
endif
let loaded_repmo = 1

if v:version < 703 || !has('patch032') || &cp
    echo "Repmo: you need at least Vim 7 and 'nocp' set"
    finish
endif

let s:sav_cpo = &cpo
set cpo&vim
" " doesn't help, we need absent cpo-< all the time
" :h map-<special>

" Customization: {{{1

" keys used to repeat motions:
if !exists("g:repmo_key")
    " " key notation is like in mappings:
    let g:repmo_key = ";"
    let g:repmo_revkey = ","
endif

" motions to map per default
if !exists("g:repmo_mapmotions")
    let g:repmo_mapmotions = "j|k h|l <C-E>|<C-Y> zh|zl w|b W|B e|ge E|gE"
    " use "<bar>" to map "|"
endif

" Functions: {{{1

" Internal Variables: {{{
let s:lastkey = ""
let s:lastrevkey = ""
 "}}}

" Internal Mappings: "{{{
nn <sid>repmo( :<c-u>call<sid>MapRepeatMotion(0,
vn <sid>repmo( :<c-u>call<sid>MapRepeatMotion(1,

 "}}}

"" Load all the original mapping into b:repmo_maparg
fun! s:MapArg(key) "{{{
  if maparg(a:key, 'n') == ""
    "" No such mapping
    let b:repmo_maparg[a:key] = {'lhs': a:key, 'rhs':a:key}
  else
    "" Mapping exist
    let b:repmo_maparg[a:key] = maparg(a:key, 'n', 0, 1)
  endif

  let l:mapflag = ""
  if has_key(b:repmo_maparg[a:key], 'silent')
    let l:mapflag .= b:repmo_maparg[a:key]['silent'] ? "<silent>" : ''
  endif
  if has_key(b:repmo_maparg[a:key], 'buffer')
    let l:mapflag .= b:repmo_maparg[a:key]['buffer'] ? "<buffer>" : ''
  endif
  if has_key(b:repmo_maparg[a:key], 'expr')
    let l:mapflag .= b:repmo_maparg[a:key]['expr'] ? "<expr>" : ''
  endif
  let b:repmo_maparg[a:key]['flag'] = l:mapflag
endfunction "}}}

func! s:RepmoMap(key, revkey, ...) abort "{{{
    " Args: {motion} {rev-motion}
    " map the {motion} key; {motion}+{rev-motion} on RHS
    let unique = a:0>=1 && a:1 ? "<unique>" : ""
    " Load the mapping status of this key
    if match(maparg(a:key, 'n'), "repmo(") == -1
      call s:MapArg(a:key)
    endif
    let lhs = printf("<special><script><silent><buffer>%s %s", unique, a:key)
    let rhs = "<sid>repmo('". substitute(a:key."','".a:revkey,"<","<lt>","g"). "')<cr>" . b:repmo_maparg[a:key]['rhs']
    if maparg(a:key, "o") == "" 
        "" prevent overloaded
        if match(b:repmo_maparg[a:key]['rhs'], "repmo(") != -1
          return ""
        endif

	" unmap this mapping
        if has_key(b:repmo_maparg[a:key], 'silent')
          exec "silent nunmap " . b:repmo_maparg[a:key]['flag'] . " " . a:key
        endif
	exec "noremap" lhs rhs
    else
	exec "nmap <buffer>" lhs rhs
	exec "xmap <buffer>" lhs rhs
    endif
    " omit :omap and :smap, protect alien :omaps (but not :smaps)
endfunc "}}}

func! <sid>MapRepeatMotion(vmode, key, revkey) "{{{
    " map ";" and ","
    " remap the motion a:key to something simpler than this function
    if a:vmode
	normal! gv
    endif
    let cnt = v:count1
    let rawkey = eval('"'.escape(b:repmo_maparg[a:key]['rhs'], '\<"').'"')
    let whitecnt = (rawkey=~'^\s$' ? "1" : "")

    if cnt > 0
	"  map ";" and ","
	if exists("g:repmo_key") && g:repmo_key != ''
	    exec "nnoremap <buffer><special>" g:repmo_key cnt.b:repmo_maparg[a:key]['rhs']
	endif
	if exists("g:repmo_revkey") && g:repmo_revkey != ''
	    exec "nnoremap <buffer><special>" g:repmo_revkey cnt.b:repmo_maparg[a:revkey]['rhs']
	endif
    endif

    let s:lastkey = a:key
    let s:lastkeynorm = whitecnt. rawkey
    let s:lastrevkey = a:revkey

    "" For vim bulit in f 
    for cmd in ["f", "F", "t", "T"]
      if s:lastkey == cmd || s:lastrevkey == cmd
        call s:TransRepeatMaps()
        break
      endif
    endfor

    "" For EasyMotion f
    if match(b:repmo_maparg[a:key]['rhs'], "EasyMotion#F") != -1 ||
 \     match(b:repmo_maparg[a:revkey]['rhs'], "EasyMotion#F") != -1 
        if exists("g:repmo_key") && g:repmo_key != ''
	    exec "nmap <buffer><special>" g:repmo_key cnt.substitute(b:repmo_maparg[a:key]['rhs'], "#F", "#REPF", 'g')
        endif
        if exists("g:repmo_revkey") && g:repmo_revkey != ''
	    exec "nmap <buffer><special>" g:repmo_revkey cnt.substitute(b:repmo_maparg[a:revkey]['rhs'], "#F", "#REPF", 'g')
        endif
    endif
endfunc "}}}

func! s:TransRepeatMaps() "{{{
    " trans is for transparent
    " check if repeating keys (e.g. ";" and ",") are overloaded, remap the
    " original commands (here: "f", "F", "t", "T")
    if g:repmo_key == ';' || g:repmo_revkey == ';'
	exec "sil! unmap <buffer> ;"
    endif
    if g:repmo_key == ',' || g:repmo_revkey == ','
	exec  "sil! unmap <buffer> ,"
    endif
    " Remap ; and , commands so they also work after t and T
    " Only do the remapping for normal and visual mode, not operator pending
    " Use @= instead of :call to prevent leaving visual mode
    exec "nmap <buffer> " . g:repmo_key    . " @=FixCommaAndSemicolon(';')<CR>"
    exec "nmap <buffer> " . g:repmo_revkey . " @=FixCommaAndSemicolon(',')<CR>"
    exec "vmap <buffer> " . g:repmo_key    . " @=FixCommaAndSemicolon(';')<CR>"
    exec "vmap <buffer> " . g:repmo_revkey . " @=FixCommaAndSemicolon(',')<CR>"
endfunc "}}}

func! s:CreateMappings(pairs) "{{{
    if empty(a:pairs)
	echomsg "Usage:  :RepmoMap {motion}|{rev-motion} ... [<unique>] ..."
	return
    endif

    if !exists('b:repmo_maparg')
      let b:repmo_maparg = {}
    endif
    let unique = 0
    for pair in split(a:pairs)
	let keys = split(pair, "|")
	if len(keys) == 2
	    call s:RepmoMap(keys[0], keys[1], unique)
	    call s:RepmoMap(keys[1], keys[0], unique)
	elseif pair == "<unique>"
	    let unique = 1
	else
	    echomsg 'Repmo: bad key pair "'. strtrans(pair). '"'
	endif
    endfor
endfunc "}}}

fun! s:EasyMotionFT(dir) "{{{
  if a:dir == 0
    exec ":call " . b:repmo_maparg[s:lastkey]['rhs']
    echo "normal! " . b:repmo_maparg[s:lastkey]['rhs']
  else
    exec b:repmo_maparg[s:lastrevkey]['rhs'] . b:repmo_easyFT
  endif
  
endfunction "}}}

function FixCommaAndSemicolon(command)"{{{
   let s:pos1 = getpos(".")
   execute "normal! " . a:command
   let s:pos2 = getpos(".")

   "" In case of at the end of line
   if s:pos1 == s:pos2
     let s:org = s:pos1

     while s:pos1 == s:pos2
       if a:command == ";"
         execute "normal! j0"
       else
         execute "normal! k$"
       endif
       let s:pos1 = getpos(".")
       if s:pos1 == s:pos2
         call setpos('.', s:org)
         break
       endif
       execute "normal! " . a:command
       let s:pos2 = getpos(".")
     endwhile
   endif
   return ""
endfunction"}}}

" Commands: {{{1
" map motions to be repeatable:
com! -nargs=* RepmoMap call s:CreateMappings(<q-args>)

" Do Inits: {{{1
if g:repmo_mapmotions != ""
    autocmd VimEnter,BufCreate * exec "RepmoMap" g:repmo_mapmotions
endif

" Modeline: {{{1
let &cpo = s:sav_cpo
unlet s:sav_cpo


" vim:set fdm=marker ts=8:
