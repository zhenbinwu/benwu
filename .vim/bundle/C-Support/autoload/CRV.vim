"*****************************************************************************
"** Name:      stlrefvim.vim - an stl-Reference manual for Vim              **
"**                                                                         **
"** Type:      global VIM plugin                                            **
"**                                                                         **
"** Author:    Daniel Price                                                 **
"**            vim(at)danprice(dot)fast-mail(dot)                           **
"**                                                                         **
"** Copyright: (c) 2008 Daniel Price                                        **
"**            This script is largely based off of crefvim by               **
"**            Christian Habermann                                          **
"**                                                                         **
"**            see stlrefvim.txt for more detailed copyright and license    **
"**            information                                                  **
"**                                                                         **
"** License:   GNU General Public License 2 (GPL 2) or later                **
"**                                                                         **
"**            This program is free software; you can redistribute it       **
"**            and/or modify it under the terms of the GNU General Public   **
"**            License as published by the Free Software Foundation; either **
"**            version 2 of the License, or (at your option) any later      **
"**            version.                                                     **
"**                                                                         **
"**            This program is distributed in the hope that it will be      **
"**            useful, but WITHOUT ANY WARRANTY; without even the implied   **
"**            warrenty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      **
"**            PURPOSE.                                                     **
"**            See the GNU General Public License for more details.         **
"**                                                                         **
"** Version:   1.0.0                                                        **
"**                                                                         **
"** History:   1.0.0   August 20 2008                                       **
"**              first release                                              **
"**                                                                         **
"**                                                                         **
"*****************************************************************************
"** Description:                                                            **
"**   This script's intention is to provide a stl-reference manual that can **
"**   be accessed from within Vim.                                          **
"**                                                                         **
"**   For futher information see stlrefvim.txt or do :help stlrefvim        **
"*****************************************************************************

if exists ("loaded_stlrefvim")
    finish
endif

let loaded_stlrefvim = 1


"*****************************************************************************
"************************* I N I T I A L I S A T I O N ***********************
"*****************************************************************************


"*****************************************************************************
"****************** I N T E R F A C E  T O  C O R E **************************
"*****************************************************************************


"*****************************************************************************
"** this function separates plugin-core-function from user                  **
"*****************************************************************************
function CRV#StlRefVimExample(str)"{{{
  let l:strng = a:str."-example"
  call CRV#STLRefVim(l:strng)
endfunction"}}}


"*****************************************************************************
"************************ C O R E  F U N C T I O N S *************************
"*****************************************************************************

"*****************************************************************************
"** ask for a word/phrase and lookup                                        **
"*****************************************************************************
function CRV#STLRefVimAskForWord()"{{{
    let l:strng = input("What to lookup: ")
    call CRV#LookUp(l:strng, "")
endfunction"}}}



"*****************************************************************************
"** input:  "str"                                                           **
"** output: empty string: "str" is not an operator                          **
"**         else:         name of tag to go to                              **
"**                                                                         **
"*****************************************************************************
"** remarks:                                                                **
"**   This function tests whether or not "str" is an operator.              **
"**   If so, the tag to go to is returned.                                  **
"**                                                                         **
"*****************************************************************************
function CRV#IsItAnOperator(style, str)"{{{

    " get first character
    let l:firstChr = strpart(a:str, 0, 1)

    " is the first character of the help-string an operator?
    if stridx("!&+-*/%,.:<=>?^|~(){}[]", l:firstChr) >= 0
        return a:style . "-operators"
    else
        return ""
    endif

endfunction"}}}



"*****************************************************************************
"** input:  "str"                                                           **
"** output: empty string: "str" is not an escape-sequence                   **
"**         else:         name of tag to go to                              **
"**                                                                         **
"*****************************************************************************
"** remarks:                                                                **
"**   This function tests whether or not "str" is an escape-sequence.       **
"**   If so, the tag to go to is returned.                                  **
"**   Note: currently \' does not work (="\\\'")                            **
"**                                                                         **
"*****************************************************************************
function CRV#IsItAnEscSequence(style, str)"{{{

    if (a:str == "\\")   || (a:str == "\\\\") || (a:str == "\\0") || (a:str == "\\x") ||
      \(a:str == "\\a")  || (a:str == "\\b")  || (a:str == "\\f") || (a:str == "\\n") ||
      \(a:str == "\\r")  || (a:str == "\\t")  || (a:str == "\\v") || (a:str == "\\?") ||
      \(a:str == "\\\'") || (a:str == "\\\"")
        return a:style . "-lngEscSeq"
    else
        return ""
    endif
    
endfunction"}}}




"*****************************************************************************
"** input:  "str"                                                           **
"** output: empty string: "str" is not a comment                            **
"**         else:         name of tag to go to                              **
"**                                                                         **
"*****************************************************************************
"** remarks:                                                                **
"**   This function tests whether or not "str" is a comment.                **
"**   If so, the tag to go to is returned.                                  **
"**                                                                         **
"*****************************************************************************
function CRV#IsItAComment(style, str)"{{{

    if (a:str == "//") || (a:str == "/*") || (a:str == "*/")
        return a:style . "-lngComment"
    else
        return ""
    endif 

endfunction"}}}




"*****************************************************************************
"** input:  "str"                                                           **
"** output: empty string: "str" is not a preprocessor                       **
"**         else:         name of tag to go to                              **
"**                                                                         **
"*****************************************************************************
"** remarks:                                                                **
"**   This function tests whether or not "str" is a preprocessor command    **
"**   or a preprocessor operator.                                           **
"**   If so, the tag to go to is returned.                                  **
"**                                                                         **
"**   Nothing is done if the help-string is equal to "if" or "else"         **
"**   because these are statements too. For "if" and "else" it's assumed    **
"**   that the statements are meant. But "#if" and "#else" are treated      **
"**   as preprocessor commands.                                             **
"**                                                                         **
"*****************************************************************************
function CRV#IsItAPreprocessor(style, str)"{{{

    " get first character
    let l:firstChr = strpart(a:str, 0, 1)
   
    " if first character of the help-string is a #, we have the command/operator
    " string in an appropriate form, so append this help-string to "stl-"
    if l:firstChr == "#"
        return a:style . "-" . a:str
    else
        " no # in front of the help string, so evaluate which command/operator
        " is meant
        if (a:str == "defined")
            return a:style . "-defined"
        else
            if (a:str == "define")  ||
              \(a:str == "undef")   ||
              \(a:str == "ifdef")   ||
              \(a:str == "ifndef")  ||
              \(a:str == "elif")    ||
              \(a:str == "endif")   ||
              \(a:str == "include") ||
              \(a:str == "line")    ||
              \(a:str == "error")   ||
              \(a:str == "pragma")
                return "\#" . a:str
            endif
        endif
    endif

endfunction"}}}




"*****************************************************************************
"** input:  "str" to lookup in stl-reference manual                         **
"** output: none                                                            **
"*****************************************************************************
"** remarks:                                                                **
"**   Lookup string "str".                                                  **
"**   Generally this function calls :help stl-"str" where "str" is the      **
"**   word for which the user wants some help.                              **
"**                                                                         **
"**   But before activating VIM's help-system some tests and/or             **
"**   modifications are done on "str":                                      **
"**   - if help-string is a comment (//, /* or */), go to section           **
"**     describing comments                                                 **
"**   - if help-string is an escape-sequence, go to section describing      **
"**     escape-sequences                                                    **
"**   - if help-string is an operator, go to section dealing with operators **
"**   - if help-string is a preprocessor command/operator, go to section    **
"**     that describes that command/operator                                **
"**   - else call :help stl-"str"                                           **
"**                                                                         **
"**   If the help-string is empty, go to contents of stl-reference manual.  **
"**                                                                         **
"*****************************************************************************
function CRV#LookUp(str, stl)"{{{

  if a:stl == ""
    if &filetype == "cpp"
      let style = "stl"
    else
      let style = "crv"
    endif
  else
    if a:stl == "cpp"
      let style = "crv"
    else
      let style = "stl"
    endif
  endif

    let l:strng = substitute(a:str, "^std::", "", "")
    if l:strng != ""

        let l:helpTag = CRV#IsItAComment(style, l:strng)
        
        if l:helpTag == ""
            let l:helpTag = CRV#IsItAnEscSequence(style, l:strng)
            
            if l:helpTag == ""
                let l:helpTag = CRV#IsItAnOperator(style, l:strng)
                
                if l:helpTag == ""
                    let l:helpTag = CRV#IsItAPreprocessor(style, l:strng)
                    
                    if l:helpTag == ""
                        let l:helpTag = style . "-" . l:strng
                    endif
                    
                endif
                
            endif
            
        endif


        " reset error message
        let v:errmsg = ""
        

        " activate help-system looking for the appropriate topic
        " suppress error messages
        silent! execute ":help " . l:helpTag
        call CRV#Syntax() 

        " if there was an error, print message
        if v:errmsg != ""
          if a:stl == ""
            call CRV#LookUp(a:str, &filetype)
          else
            echo "  No help found for \"" .a:str . "\""
          endif
        endif
    else
        " help string is empty, so show contents of manual
        if style == "stl"
          execute ":help stlrefvim"
        else
          execute ":help crefvim"
        endif
    endif
    
    
endfunction"}}}



"*****************************************************************************
"** input:  "str" to lookup in stl-reference manual                         **
"** output: none                                                            **
"*****************************************************************************
"** remarks:                                                                **
"**   lookup string "str".                                                  **
"**   If there is no string, ask for word/phrase.                           **
"**                                                                         **
"*****************************************************************************
function CRV#STLRefVim(str)"{{{

    let s:strng = a:str

    if s:strng == ""                     " is there a string to search for?
        call CRV#STLRefVimAskForWord()
    else
        call CRV#LookUp(s:strng, "")
    endif

endfunction"}}}

fun! CRV#Syntax() "{{{
  if tolower(expand("%:t"))=="crefvim.txt"
    syn match helpCRVSubStatement  "statement[0-9Ns]*"   contained
    syn match helpCRVSubCondition  "condition[0-9]*"     contained
    syn match helpCRVSubExpression "expression[0-9]*"    contained
    syn match helpCRVSubExpr       "expr[0-9N]"          contained
    syn match helpCRVSubType       "type-name"           contained
    syn match helpCRVSubIdent      "identifier"          contained
    syn match helpCRVSubIdentList  "identifier-list"     contained
    syn match helpCRVSubOperand    "operand[0-9]*"       contained
    syn match helpCRVSubConstExpr  "constant-expression[1-9Ns]*" contained
    syn match helpCRVSubClassSpec  "storage-class-specifier"  contained
    syn match helpCRVSubTypeSpec   "type-specifier"      contained
    syn match helpCRVSubEnumList   "enumerator-list"     contained
    syn match helpCRVSubDecl       "declarator"          contained
    syn match helpCRVSubRetType    "return-type"         contained
    syn match helpCRVSubFuncName   "function-name"       contained
    syn match helpCRVSubParamList  "parameter-list"      contained
    syn match helpCRVSubReplList   "replacement-list"    contained
    syn match helpCRVSubNewLine    "newline"             contained
    syn match helpCRVSubMessage    "message"             contained
    syn match helpCRVSubFilename   "filename"            contained
    syn match helpCRVSubDigitSeq   "digit-sequence"      contained
    syn match helpCRVSubMacroNames "macro-name[s]*"      contained
    syn match helpCRVSubDirective  "directive"           contained


    syn match helpCRVignore     "\$[a-zA-Z0-9\\\*/\._=()\-+%<>&\^|!~\?:,\[\];{}#\'\" ]\+\$" contains=helpCRVstate
    syn match helpCRVstate      "[a-zA-Z0-9\\\*/\._=()\-+%<>&\^|!~\?:,\[\];{}#\'\" ]\+"   contained contains=helpCRVSub.*



    "hi helpCRVitalic  term=italic cterm=italic gui=italic
    "hi helpCRVitalic  term=italic cterm=italic gui=italic
    hi helpCRVitalic   gui=BOLD guifg=#2020FF guibg=#FFFFFF

    hi def link  helpCRVstate          Comment
    hi def link  helpCRVSubStatement   helpCRVitalic
    hi def link  helpCRVSubCondition   helpCRVitalic
    hi def link  helpCRVSubExpression  helpCRVitalic
    hi def link  helpCRVSubExpr        helpCRVitalic
    hi def link  helpCRVSubOperand     helpCRVitalic
    hi def link  helpCRVSubType        helpCRVitalic
    hi def link  helpCRVSubIdent       helpCRVitalic
    hi def link  helpCRVSubIdentList   helpCRVitalic
    hi def link  helpCRVSubConstExpr   helpCRVitalic
    hi def link  helpCRVSubClassSpec   helpCRVitalic
    hi def link  helpCRVSubTypeSpec    helpCRVitalic
    hi def link  helpCRVSubEnumList    helpCRVitalic
    hi def link  helpCRVSubDecl        helpCRVitalic
    hi def link  helpCRVSubRetType     helpCRVitalic
    hi def link  helpCRVSubFuncName    helpCRVitalic
    hi def link  helpCRVSubParamList   helpCRVitalic
    hi def link  helpCRVSubReplList    helpCRVitalic
    hi def link  helpCRVSubNewLine     helpCRVitalic
    hi def link  helpCRVSubMessage     helpCRVitalic
    hi def link  helpCRVSubFilename    helpCRVitalic
    hi def link  helpCRVSubDigitSeq    helpCRVitalic
    hi def link  helpCRVSubMacroNames  helpCRVitalic
    hi def link  helpCRVSubDirective   helpCRVitalic
    hi def link  helpCRVignore         Ignore
  endif

  if tolower(expand("%:t"))=="stlrefvim.txt"
        syntax keyword helpNote Description Definition Preconditions 
        syntax keyword helpNote Complexity Prototype
  endif
endfunction "}}}
