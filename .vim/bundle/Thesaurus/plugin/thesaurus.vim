" File Description {{{
" =============================================================================
"
" This plugin is based on Nick Coleman's Thesaurus blog 
" http://www.nickcoleman.org/blog/index.cgi?post=vim-thesaurus!201202170802! \
"   general%2Cblogging%2Cinternet%2Cprogramming%2Csoftware%2Cunix
" I am simply wrap it up for my usage.
"                                                  by Ben Wu
"                                                     benwu@fnal.gov
" Usage :
"       Map the K key to the ReadThesaurus function
" TODO:
"  Map s and a to walk around term that are separated by comma,
"  where s walks among Synonyms and a walks among Antonyms. Terms under cursor
"  would be underlined for highlighting. <CR> will insert such word to the
"  original position.
"
" =============================================================================
" }}}

if exists("g:loaded_thesaurus") && g:loaded_thesaurus
    finish
endif

let g:loaded_thesaurus = 1
let s:thesaurus_height = 20
let s:thesaurus_win_maximized = 0


fun! ReadThesaurus() "{{{
   " Assign current word under cursor to a script variable
   let s:thes_word = expand('<cword>')


   let s:thesaurus_window = -1
   for bufnr in tabpagebuflist()					
     if bufname(bufnr) == "__Thesaurus__"
       let s:thesaurus_window = bufwinnr(bufnr)
     endif
   endfor

   if s:thesaurus_window == -1
     " Open a new window, keep the alternate so this doesn't clobber it. 
     exec "keepalt " . s:thesaurus_height . "split __Thesaurus__"
   else
     exec s:thesaurus_window . "wincmd w"
   endif


   setlocal modifiable
   " Show cursor word in status line
   exe "setlocal statusline=Thesaurus:" . s:thes_word
   " Set buffer options for scratch buffer
   setlocal noswapfile nobuflisted nowrap nospell 
     \buftype=nofile bufhidden=hide 
   " Delete existing content
   1,$d
   " Run the thesaurus script
   exe ":0r !bash $HOME/.vim/bundle/Thesaurus/plugin/thesaurus.sh " . s:thes_word 

   " Goto first line
   1
   " Set file type to 'thesaurus'
   set filetype=thesaurus
   setlocal nomodifiable

   " Map q to quit without confirm
   nmap <buffer> q :q<CR>
   " Map n and p to jump through Main Entry
   nnoremap <buffer> <silent> n :call search('^\s*Main Entry:\s.*$', 'W')<CR>z.
   nnoremap <buffer> <silent> p 0:call search('^\s*Main Entry:\s.*$', 'bW')<CR>z.

   " Map s and S for browsing Synonym words
   nnoremap <buffer> <silent> s :call UseSynonym(1, 1)<CR>
   nnoremap <buffer> <silent> S :call UseSynonym(1, -1)<CR>
   " Map a and A for browsing Antonyms words
   nnoremap <buffer> <silent> a :call UseSynonym(-1, 1)<CR>
   nnoremap <buffer> <silent> A :call UseSynonym(-1, -1)<CR>
   " Map <CR> and <C-\> for inserting words
   nnoremap <buffer> <silent> <CR> :call <SID>EnterSynonym()<CR>
   nnoremap <buffer> <silent> <C-\> :call <SID>InsertWord(expand('<cword>'))<CR>
   nnoremap <buffer> <silent> x :call <SID>Thesaurus_Window_Zoom()<CR>
endfun   "}}}

function! UseSynonym(type, action) "{{{
let s:enter=""

python << EOF

import re
import vim

def GetPosition():
    ### First get the sckeleton of the file
    lmain = []
    lsyn = []
    lnote = []
    lant = []
    lblock = []
    ## define the return value
    ## 0 for inseart current text
    ## 1 for Synonyms
    ## -1 for Antonyms
    type = int(vim.eval("a:type"))
    ## define the action value
               ## 0 for insert the current text
               ## -1 backward
               ## 1 forward
    action = int(vim.eval("a:action"))

    ## Get term under the current position
    curpos = vim.eval("getpos('.')")
    currentl = int(curpos[1])
    valpos = int(curpos[1] + curpos[2])

    i = 0 ## line number
    for line in vim.current.buffer:
        if re.search('Main Entry:.*', line):
            lmain.append(i)
        if re.search('Synonyms:.*', line):
            lsyn.append(i)
        if re.search('Antonyms:.*', line):
            lant.append(i)
        if re.search('Notes:.*', line):
            lnote.append(i)
        if re.search('^\s\n', line):
            lblock.append(i)
        i+=1

    lall = lmain + lsyn + lant + lnote + lblock
    lall.sort()
    block = []

    ## Get the main block
    for main in range(len(lmain)):
        if currentl >= lmain[-1]:
            block = [lmain[-1], i]
        elif currentl >= lmain[main] and currentl < lmain[main+1]:
            block = [lmain[main], lmain[main+1]]

    ## Get the upper limit for the block
    found = False
    if type == 1:
        for syn in lsyn:
            if syn >= block[0] and syn < block[1]:
                block[0] = syn
                found = True

    if type == -1:
        found = False
        for ant in lant:
            if ant >= block[0] and ant < block[1]:
                block[0] = ant
                found = True

    if type == 0:
        found = False
        for syn in range(len(lsyn)):
            if currentl >= lsyn[-1]:
                block = [lsyn[-1], block[1]]
            elif currentl >= lsyn[syn] and currentl < lsyn[syn+1]:
                block[0] = lsyn[syn]
        for ant in range(len(lant)):
            if lant[ant] >= block[0] and lant[ant] <= block[1]:
                if currentl >= lant[ant]:
                    block[0] = lant[ant]
        found = True

    ## Get the lower limit for the block
    for blk in lall:
        if blk > block[0] and blk < block[1]:
            block[1] = blk

    if found:
        joint = ''
        for l in range(block[0], block[1]):
            joint+=vim.current.buffer[l]
    else:
      return None

    terms = joint.split(',')
    striped = []
    searchterm = []
    termpos = {}
    for term in terms:
        if term.find(':') != -1:
            term = term.split(':')[1]
        term = term.strip()
        term = term.replace("\n", " ")
        term=re.sub("\s+", " ", term)
        striped.append(term)
        term = term.replace(" ", "\_s\+")
        searchterm.append(term.replace("\'", "\''"))


    ## Set the cursor where the search begin
    cur ="cursor(" + str(block[0]) + ", 0)"
    vim.eval(cur)

    ## Get the position map
    for i in range(len(searchterm)):
        command = "searchpos("
        command += "'" + searchterm[i] + "', "
        command += "'', "
        command += str(block[1])
        command += ")"
        var = vim.eval(command)
        pos = int(var[0] + var[1])
        termpos[striped[i]] = pos

    found = False
    foundterm = ''
    sign = 1
    index = -1
    for i in range(len(striped)):
        var = termpos[striped[i]]
        if valpos == var:
            foundterm = striped[i]
            index = i
            break

        if i == 0 and valpos < var:
            foundterm = striped[i]
            index = -1
            break
        if i == len(termpos) and valpos > var:
            foundterm = striped[i]
            index = i
            break

        tempsign = -1
        if valpos >= var:
            tempsign = 1
        if sign * tempsign < 0 :
            foundterm = striped[i-1]
            index = i-1
            break
        sign = tempsign

    ## Set the cursor where the search begin
    cur ="cursor(" + curpos[1] + ", " + curpos[2] +  ")"
    vim.eval(cur)

    if action == 0:
        command = "let s:enter=\""+foundterm+"\"";
        vim.command(command)
        #vim.eval(command)
        #return foundterm
    elif action == 1: 
        if index == len(striped)-1:
           index = -1
        pos = str(termpos[striped[index+1]])
        cur ="cursor(" + pos[:len(pos)-2] + ", " + pos[len(pos)-2:len(pos)] +  ")"
        vim.eval(cur)
        vim.command("syntax clear Thesaurus")
        syn = "syntax match Thesaurus /\<" + searchterm[index+1] +"\>/"
        vim.command(syn)
    elif action == -1: 
        if index == 0:
           index = len(striped)
        pos = str(termpos[striped[index-1]])
        cur ="cursor(" + pos[:len(pos)-2] + ", " + pos[len(pos)-2:len(pos)] +  ")"
        vim.eval(cur)
        vim.command("syntax clear Thesaurus")
        syn = "syntax match Thesaurus /\<" + searchterm[index-1] +"\>/"
        vim.command(syn)
        
GetPosition()
EOF

return s:enter
endfunction   "}}}

function! s:EnterSynonym() "{{{
    let s:word = UseSynonym(0,0)
    bwipeout!
    execute "normal edbxi" . s:word
endfunction   "}}}

function! s:InsertWord(word) "{{{
    bwipeout!
    execute "normal edbxi" . a:word
endfunction "}}}

" Zoom (maximize/minimize) the thesaurus window
function! s:Thesaurus_Window_Zoom()
    if s:thesaurus_win_maximized
        " Restore the window back to the previous size
        exe 'resize ' . s:thesaurus_height
        let s:thesaurus_win_maximized = 0
    else
        " Set the window size to the maximum possible without closing other
        " windows
        resize
        let s:thesaurus_win_maximized= 1
    endif
endfunction

" Map the K key to the ReadThesaurus function
nnoremap <silent> <leader>rt :call ReadThesaurus()<CR><CR>

