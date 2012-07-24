function! UseSynonym()
    "let line = a:line
    "let pos = getpos('.')
    "let arglist_sub = a:line
python << EOF

import re
import vim

def GetPosition():
    lmain = []
    lsyn = []
    lnote = []
    lant = []
    lblock = []
    currentl = vim.eval('getpos(".")')[1]
    type = 0
    i = 1

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
    print lall
    block = []
    found = False

    ## Get the main block
    for main in range(len(lmain)):
         print lmain[main]
         if currentl >= lmain[main] and currentl < lmain[main+1]:
            block = [lmain[main], lmain[main+1]]
    print block

    ### Get the upper limit for the block
    #if jjjjjtype == 0:
    #    for syn in lsyn:
    #        if syn >= block[0] and syn < block[1]:
    #            block[0] = syn
    #            found = True

    #if type == 1:
    #    found = False
    #    for ant in lant:
    #        if ant >= block[0] and ant < block[1]:
    #            block[0] = ant
    #            found = True

    ### Get the lower limit for the block
    #for blk in lall:
    #    if blk > block[0] and blk < block[1]:
    #        block[1] = blk
    #print block

    #if found:
    #    joint = ''
    #    for l in range(block[0], block[1]):
    #        joint.join(vim.current.buffer[l])
    #        joint+=vim.current.buffer[l]
    #        #print f.readvim.current.buffer()[l]

    #terms = joint.split(',')
    #striped = []
    #for term in terms:
    #    if term.find(':') != -1:
    #        term = term.split(':')[1]
    #    #print term
    #    term = term.replace("\n", " ")
    #    term = term.strip()
    #    #print term
    #    striped.append(re.sub("\s+", " ", term))
    #    #term = term.replace(" *", " ")

    #print striped

    #        #print currentmain
    #        #for syn in range(len(lsyn)):
    #            #print lsyn[syn]
    #            #if currentmain >= lsyn[syn] and currentmain < lsyn[syn-1]:
    #                #print "ddddddddd"
    #                #print lsyn[syn]
GetPosition()
EOF


    ""let Sstart = search('.*Definition*', 'b', line("w0"))
    "echo line("w0")
    "let Sstart = search('.*Synonyms:*', '', )
    "echo Sstart
    "if Sstart == 0
      "let Sstart = search('.*Synonyms:*', 'b', line("w0"))
    "endif
    "echo Sstart
    "let end = search('.*Notes:.*', '', line("w$"))
    "echo end
    "let n = 1
    "while n <= argc()	    " loop over all files in arglist
      "exe "argument " . n
      "" start at the last char in the file and wrap for the
      "" first search to find match at start of file
      "normal G$
      "let flags = "w"
      "while search("foo", flags) > 0
         "s/foo/bar/g
         "let flags = "W"
      "endwhile
      "update		    " write the file if modified
      "let n = n + 1
    "endwhile

  "while stridx(arglist_sub, '(')>=0 && stridx(arglist_sub, ')')>=0
    "let arglist_sub = substitute(arglist_sub , '(\([^()]\{-}\))', '\="<".substitute(submatch(1), ",", "_", "g").">"', 'g')
    """"echo 'sub single quot: ' . arglist_sub
  "endwhile

    "let arglist_sub = substitute(line, '\([^,]\{-}\)', '\="<".submatch(1), ",", "_", "g").">"', 'g')
    "echo arglist_sub
    

    "let syn = substitute(line, "^ ", '', '')

    "if line =~ '^ \w\+'
        "let syn = substitute(line, "^ ", '', '')
        "let syn = substitute(syn, "\n$", '', '')
        "let syn = substitute(syn, ' ([^)]\+)$', '', '')

        "bwipeout!

        "let pos = getpos('.')
        "let line = getline(pos[1])
        "if line[pos[2]] =~ '\w'
            "execute "normal edbxi" . syn
        "else
            "execute "normal bdei " . syn
        "endif
    "endif
endfunction

"call UseSynonym()
