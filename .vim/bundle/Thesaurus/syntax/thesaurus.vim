" Vi syntax file
" Language: text dump from online thesaurus
" Maintainer: Nick Coleman
" Last Change:  2012 Feb 18
" Remark: for the online thesaurus script by Nick Coleman
  
if exists("b:current_syntax")
    finish
endif

" Setup
" syntax clear    " only useful for testing
syntax case match
setlocal iskeyword+=:

" Entry name rules
syntax match thesMainEntry /Main Entry: */ contained
syntax region  thesDefinition start=/Definition: /  end=/$/
syntax keyword thesNotes Notes: contained
syntax keyword thesSynonyms Synonyms:
syntax region  thesAntonyms start=/Antonyms:/  end=/$/ 

" give the pronunciation region a special name
syntax region thesPronunciation start=/pronunciation \[/ end=/$/ contained

" Entry contents rules
syntax region thesMainWord start=/Main Entry:/  end=/$/ contains=CONTAINED keepend
syntax region thesNotesEntry start=/Notes:/  end=/^ *$/ contains=thesNotes,thesAntonyms keepend 

" Highlighting

hi link thesMainEntry     Keyword
hi  thesMainWord      term=bold cterm=bold gui=bold
hi link thesDefinition      String
hi link thesNotes     Number
hi link thesNotesEntry      Number
hi link thesSynonyms      Statement
hi link thesAntonyms      Type
hi link thesPronunciation   Comment

hi def Thesaurus term=underline cterm=underline gui=underline

let b:current_syntax = "thesaurus"
