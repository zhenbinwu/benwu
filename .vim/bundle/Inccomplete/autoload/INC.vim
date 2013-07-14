" Name:            inccomplete
" Author:          xaizek  <xaizek@lavabit.com>
" Maintainers:     drougas <drougas@cs.ucr.edu>
" Version:         1.6.32
" License:         Same terms as Vim itself (see :help license)
"
" See :help inccomplete for documentation.

if exists('g:loaded_inccomplete2')
    finish
endif

let g:loaded_inccomplete2 = 1
let g:inccomplete_cache = {}

if !exists('g:inccomplete_autoselect')
    let g:inccomplete_autoselect = 1
endif

if !exists('g:inccomplete_findcmd')
    let g:inccomplete_findcmd = ''
endif

if !exists('g:inccomplete_addclosebracket')
    let g:inccomplete_addclosebracket = 'always'
endif

if !exists('g:inccomplete_sort')
    let g:inccomplete_sort = ''
endif

if !exists('g:inccomplete_showdirs')
    let g:inccomplete_showdirs = 0
endif

if !exists('g:inccomplete_appendslash')
    let g:inccomplete_appendslash = 0
endif

" this is the 'omnifunc'
function! ICComplete_1(findstart, base)
  " did user request #include completion?
  let s:passnext = getline('.') !~ '^\s*#\s*include\s*\%(<\|"\)'
  if !s:passnext
    return match(getline('.'), '<\|"') + 1
  endif
endfunction


function! INC#ICComplete_2(findstart, base)
  let l:pos = match(getline('.'), '<\|"')
  let l:bracket = getline('.')[l:pos : l:pos]

  "" Remove the tail 
  let l:save_cursor = getpos(".")
  normal $
  let l:end_cursor = getpos(".")
  call setpos('.', l:save_cursor)
  if l:end_cursor[2] - l:save_cursor[2] > 0
    normal D
  endif

  if empty(a:base) && l:bracket == '<' && exists('s:fullCached')
    return s:fullCached
  endif

  let l:old_cwd = getcwd()
  lcd %:p:h

  " get list of all candidates and reduce it to those starts with a:base
  let l:inclst = INC#ICGetList(l:bracket == '"', a:base)
  let l:inclst = INC#ICFilterIncLst(0, l:inclst, a:base)
  "let l:inclst = INC#ICFilterIncLst(l:bracket == '"', l:inclst, a:base)

  if g:inccomplete_addclosebracket != 'always'
    " determine close bracket
    let l:closebracket = ['"', '>'][l:bracket == '<']
    if getline('.')[l:pos + 1 :] =~ l:closebracket.'\s*$'
      let l:closebracket = ''
    endif
  else
    let l:closebracket = ''
  endif

  " form list of dictionaries
  let [l:pos, l:sl1, l:sl2] = INC#ICParsePath(a:base)
  let l:comlst = []
  for l:increc in l:inclst
    if empty(l:increc[1])
      continue
    endif

    if isdirectory(l:increc[0].'/'.l:increc[1])
      let l:slashidx = strridx(l:increc[1], l:sl2)
      if l:increc[1][l:slashidx + 1] == '.'
        continue
      endif

      let l:strend = g:inccomplete_appendslash ? l:sl2 : ''
      let l:slash = l:sl2
    else
      let l:strend = l:closebracket
      let l:slash = ''
    endif

    let l:item = {
          \ 'word': l:increc[1].l:strend,
          \ 'abbr': l:increc[1].l:slash,
          \ 'menu': INC#ICModifyPath(l:increc[0]),
          \ 'dup': 0
          \}
    call add(l:comlst, l:item)
  endfor

  execute 'lcd' l:old_cwd

  let l:result = INC#SortList(l:comlst)

  if empty(a:base) && l:bracket == '<'
    let s:fullCached = l:result
  endif

  return l:result
endfunction



" sorts completion list
function INC#SortList(lst)
    if g:inccomplete_sort == 'ignorecase'
        return sort(a:lst, 's:IgnoreCaseComparer')
    else
        return sort(a:lst, 's:Comparer')
    endif
endfunction

function s:IgnoreCaseComparer(i1, i2)
    return a:i1['abbr'] == a:i2['abbr'] ? 0 :
                \ (a:i1['abbr'] > a:i2['abbr'] ? 1 : -1)
endfunction

function s:Comparer(i1, i2)
    return a:i1['abbr'] ==# a:i2['abbr'] ? 0 :
                \ (a:i1['abbr'] ># a:i2['abbr'] ? 1 : -1)
endfunction

" modifies path correctly on Windows
function! INC#ICModifyPath(path)
    let l:drive_regexp = '\C^[a-zA-Z]:'
    let l:modified = fnamemodify(a:path, ':p:.')
    let l:prefix = ''
    if has('win32') && a:path =~ l:drive_regexp && !empty(l:modified)
        let l:prefix = matchstr(a:path, l:drive_regexp)
    endif
    return l:prefix.l:modified
endfunction

" filters search results
function! INC#ICFilterIncLst(user, inclst, base)
    let [l:pos, l:sl1, l:sl2] = INC#ICParsePath(a:base)

    " filter by filename
    let l:filebegin = a:base[strridx(a:base, l:sl2) + 1:]
    let l:inclst = filter(copy(a:inclst),
                        \ '!empty(v:val[1]) && v:val[1] =~ "^".l:filebegin')

    " correct slashes in paths
    if l:sl1 == '/'
        call map(l:inclst, '[substitute(v:val[0], "\\\\", "/", "g"), v:val[1]]')
    else
        call map(l:inclst, '[substitute(v:val[0], "/", "\\\\", "g"), v:val[1]]')
    endif

    if l:pos >= 0
        " filter by subdirectory name
        let l:dirend0 = a:base[:l:pos]
        if a:user
            let l:dirend1 = fnamemodify(expand('%:p:h').'/'.l:dirend0, ':p')
        else
            let l:dirend1 = l:dirend0
        endif
        if l:sl1 == '/'
            let l:dirend2 = substitute(l:dirend1, "\\\\", "/", "g")
        else
            let l:dirend2 = escape(l:dirend1, '\')
        endif
        if a:user
            call filter(l:inclst, 'v:val[0] =~ "^".l:dirend2."[\\/]*$"')
        else
            call filter(l:inclst, 'v:val[0] =~ "'.l:sl1.'".l:dirend2."$"')
        endif

        " move end of each path to the beginning of filename
        let l:cutidx = - (l:pos + 2)
        if !empty(l:inclst) && l:inclst[0][0][l:cutidx + 1:] != l:dirend0
                    \ && a:user
            let l:path = expand('%:p:h')
            call map(l:inclst, '[l:path, l:dirend0.v:val[1]]')
        else
            call map(l:inclst, '[v:val[0][:l:cutidx], l:dirend0.v:val[1]]')
        endif
    endif

    return l:inclst
endfunction

" searches for files that can be included in path
" a:user determines search area, when it's not zero look only in '.', otherwise
" everywhere in path except '.'
function! INC#ICGetList(user, base)
  if a:user
    let l:dir = expand('%:h:p')
    let l:result = INC#ICFindIncludes(1, [l:dir] + INC#ICGetSubDirs([l:dir], a:base))
  else
    let l:result = []
  endif

  if a:user
    let l:pathlst = INC#ICAddNoDupPaths([], INC#ICGetClangLocalIncludes())
  else
    " prepare list of directories
    let l:pathlst = INC#ICAddNoDupPaths(split(&path, ','), INC#ICGetClangGlobalIncludes())
  endif

  let l:pathlst = INC#ICAddNoDupPaths(l:pathlst,
        \ INC#ICGetSubDirs(l:pathlst, a:base))
  call reverse(sort(l:pathlst))

  " divide it into sublists
  let l:noncached = filter(copy(l:pathlst),
        \ '!has_key(g:inccomplete_cache, v:val)')
  let l:cached = filter(l:pathlst, 'has_key(g:inccomplete_cache, v:val)')

  " add noncached entries
  let l:result += INC#ICFindIncludes(0, l:noncached)

  " add cached entries
  for l:incpath in l:cached
    call map(copy(g:inccomplete_cache[l:incpath]),
          \ 'add(l:result, [l:incpath, v:val])')
  endfor

  return l:result
endfunction

" gets list of header files using find
function! INC#ICFindIncludes(user, pathlst)
    " test arguments
    if empty(a:pathlst)
        return []
    endif
    if !a:user
        if empty(g:inccomplete_findcmd)
            let l:regex = '.*[/\\][-_a-z0-9]\+\(\.hpp\|\.h\)\?$'
        else
            let l:regex = '.*[/\\][-_a-z0-9]+\(\.hpp\|\.h\)?$'
        endif
    else
        let l:regex = '.*\(\.hpp\|\.h\)$'
    endif

    " execute find
    if empty(g:inccomplete_findcmd)
        let l:pathstr = substitute(join(a:pathlst, ','), '\\', '/', 'g')
        let l:found = globpath(l:pathstr, '*', 1)
        let l:foundlst = split(l:found, '\n')

        if g:inccomplete_showdirs
            call filter(l:foundlst,
                      \ "v:val =~ '".l:regex."' || isdirectory(v:val)")
        else
            call filter(l:foundlst, "v:val =~ '".l:regex."'")
        endif
    else
        " substitute in the next command is for Windows (it removes backslash in
        " \" sequence, that can appear after escaping the path)
        let l:substcmd = 'substitute(shellescape(v:val), ''\(.*\)\\\"$'','.
                       \ ' "\\1\"", "")'


        let l:pathstr = join(map(copy(a:pathlst), l:substcmd), ' ')
        let l:iregex = ' -iregex '.shellescape(l:regex)
        let l:dirs = g:inccomplete_showdirs ? ' -or -type d' : ''
        let l:found = system(g:inccomplete_findcmd.' -L '.
                           \ l:pathstr.' -maxdepth 1 -type f'.l:iregex.l:dirs)
        let l:foundlst = split(l:found, '\n')
    endif
    unlet l:found " to free some memory

    " prepare a:pathlst by forming regexps
    for l:i in range(len(a:pathlst))
        let g:inccomplete_cache[a:pathlst[i]] = []
        let l:tmp = substitute(a:pathlst[i], '\', '/', 'g')
        let a:pathlst[i] = [a:pathlst[i], '^'.escape(l:tmp, '.')]
    endfor

    " process the results of find
    let l:result = []
    for l:file in l:foundlst
        let l:file = substitute(l:file, '\', '/', 'g')
        " find appropriate path
        let l:pathlst = filter(copy(a:pathlst), 'l:file =~ v:val[1]')
        if empty(l:pathlst)
            continue
        endif
        let l:incpath = l:pathlst[0]
        " add entry to list
        let l:left = l:file[len(l:incpath[0]):]
        if l:left[0] == '/' || l:left[0] == '\'
            let l:left = l:left[1:]
        endif
        call add(l:result, [l:incpath[0], l:left])
        " and to cache
        call add(g:inccomplete_cache[l:incpath[0]], l:left)
    endfor
    return l:result
endfunction

" retrieves include directories from b:clang_user_options 
function! INC#ICGetClangLocalIncludes()
    if !exists('b:clang_user_options')
        return []
    endif
    let l:lst = split(b:clang_user_options)
    let l:lst = filter(l:lst, 'v:val =~ "\\C^-I"')
    let l:lst = map(l:lst, 'v:val[2:]')
    let l:lst = map(l:lst, 'fnamemodify(v:val, ":p")')
    let l:lst = map(l:lst, 'substitute(v:val, "\\\\", "/", "g")')
    return l:lst
endfunction

" retrieves include directories from g:clang_user_options
function! INC#ICGetClangGlobalIncludes()
    if !exists('g:clang_user_options')
        return []
    endif
    let l:lst = split(g:clang_user_options)
    let l:lst = filter(l:lst, 'v:val =~ "\\C^-I"')
    let l:lst = map(l:lst, 'v:val[2:]')
    let l:lst = map(l:lst, 'fnamemodify(v:val, ":p")')
    let l:lst = map(l:lst, 'substitute(v:val, "\\\\", "/", "g")')
    return l:lst
endfunction

" searches for existing subdirectories
function! INC#ICGetSubDirs(pathlst, base)
    let [l:pos, l:sl, l:sl2] = INC#ICParsePath(a:base)
    if l:pos < 0
        return []
    endif

    " search
    let l:dirend = a:base[:l:pos]
    let l:pathlst = join(a:pathlst, ',')
    let l:subdirs = finddir(l:dirend, l:pathlst, -1)

    " path expanding
    call map(l:subdirs, 'fnamemodify(v:val, ":p:h")')

    " ensure that path ends with slash
    let l:mapcmd = 'substitute(v:val, "\\([^'.l:sl.']\\)$", "\\1'.l:sl.'", "g")'
    call map(l:subdirs, l:mapcmd)

    return l:subdirs
endfunction

" returns list of three elements: [name_pos, slash_for_regexps, ordinary_slash]
function! INC#ICParsePath(path)
    let l:iswindows = has('win16') || has('win32') || has('win64') ||
                    \ has('win95') || has('win32unix')

    " determine type of slash
    let l:path = a:path
    let l:pos = strridx(a:path, '/')
    let l:sl1 = '/'
    let l:sl2 = '/'
    if l:iswindows && (empty(a:path) || l:pos < 0)
        let l:pos = strridx(a:path, '\')
        let l:sl1 = '\\\\'
        let l:sl2 = '\'
    endif
    return [l:pos, l:sl1, l:sl2]
endfunction

" adds one list of paths to another without duplicating items
function! INC#ICAddNoDupPaths(lista, listb)
    let l:result = []
    call INC#ICPrepPaths(a:lista)
    call INC#ICPrepPaths(a:listb)
    for l:item in a:lista + a:listb
        if index(l:result, l:item) == -1
            call add(l:result, l:item)
        endif
    endfor
    return l:result
endfunction

" converts list of paths to a list of absolute paths and excudes '.' directory
function! INC#ICPrepPaths(lst)
    call filter(a:lst, '!empty(v:val) && v:val != "."')
    return map(a:lst, 'fnamemodify(v:val, ":p")')
endfunction

