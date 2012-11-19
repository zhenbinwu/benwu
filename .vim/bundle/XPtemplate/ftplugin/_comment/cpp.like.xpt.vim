" NOTE: You can include this file into which uses CPP comment format.  But It
"       is recommended to include _comment/doubleSign (or singleSign,
"       singleDouble) directly.
XPTemplate priority=like-

XPTvar $CL  /*
XPTvar $CM   *
XPTvar $CR   */

XPTvar $CS  //

"XPTinclude
      "\ _comment/singleDouble

let s:f = g:XPTfuncs()
fun! s:f._xCommentMidIndent()
    let l = self.GetVar( '$CL' )
    let m = self.GetVar( '$CM' )
    
    if len( l ) <= len( m )
        return ''
    else
        return '      '[ : len( l ) - len( m ) - 1 ]
    endif
endfunction
XPT _d_commentDoc hidden wrap	" $CL$CM ..
`$CL^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^
`$_xCommentMidIndent$CM `cursor^
`$_xCommentMidIndent$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CM^`$CR^ 

XPT commentDoc   alias=_d_commentDoc
