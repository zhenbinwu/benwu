XPTemplate priority=spec

let s:f = g:XPTfuncs()

XPTvar $CURSOR_PH     <!-- cursor -->

XPTinclude
      \ _common/common

XPTvar $CL    <!--
XPTvar $CM
XPTvar $CR    -->
XPTinclude
      \ _comment/doubleSign


" ========================= Function and Variables =============================

fun! s:f.xml_att_val()
    if self.Phase()=='post'
        return ''
    endif

    let name = self.ItemName()
    return self.Vmatch('\V' . name, '\V\^\s\*\$')
          \ ? ''
          \ : '="val" ' . name
endfunction

fun! s:f.xml_tag_ontype()
    let v = self.V()
    if v =~ '\V\s\$'
        let v = substitute( v, '\V\s\*\$', '', 'g' )
        return self.Next( v )
    endif
    return v
endfunction

fun! s:f.xml_attr_ontype()
    let v = self.V()
    if v =~ '\V=\$'
        return self.Next()
    elseif len( v ) > 2 && v =~ '\V""\$'
        return self.Next( v[ 0 : -2 ] )
    else
        return v
    endif

endfunction

fun! s:f.xml_create_attr_ph()
    " let prev = self.PrevItem( -1 )
    if !self.HasStep( 'x' )
        return self.Embed('` `x^' . '`att*^')
    endif

    let prev = self.Reference( 'x' )

    if prev =~ '=$' 
        return self.Embed('`"`x`"^' . '`att*^')
    elseif prev =~ '"$'
        return self.Embed('` `x^' . '`att*^')
    else
        return self.Next( '' )
    endif
endfunction

fun! s:f.xml_close_tag()
    let v = self.V()
    if v[ 0 : 0 ] != '<' || v[ -1:-1 ] != '>'
        return ''
    endif

    let v = v[ 1: -2 ]

    if v =~ '\v/\s*$|^!'
        return ''
    else
        return '</' . matchstr( v, '\v^\S+' ) . '>'
    endif
endfunction

fun! s:f.xml_cont_helper()
    let v = self.V()
    if v =~ '\V\n'
        return self.ResetIndent( -s:nIndent, "\n" )
    else
        return ''
    endif
endfunction

let s:nIndent = 0
fun! s:f.xml_cont_ontype()
    let v = self.V()
    if v =~ '\V\n'
        let v = matchstr( v, '\V\.\*\ze\n' )
        let s:nIndent = &indentexpr != ''
              \ ? eval( substitute( &indentexpr, '\Vv:lnum', 'line(".")', '' ) ) - indent( line( "." ) - 1 )
              \ : self.NIndent()

        return self.Finish( v . "\n" . repeat( ' ', s:nIndent ) )
    else
        return v
    endif
endfunction

XPT red " %REDCOLOR...
%RED% `content^ %ENDCOLOR%

XPT link " linking...
[[`Address^][`Text^]]

XPT bold " bold text...
*`Text^*

XPT mono " monospaced text...
=`Text^=

XPT twisty " make a twisty
%TWISTY{mode="div" showlink="Show alternate instructions" hidelink="Hide alternate instructions" remember="on" 
                showimgleft="%ICONURLPATH{toggleopen-small}%" 
                hideimgleft="%ICONURLPATH{toggleclose-small}%"}% 
`cursor^
%ENDTWISTY%

XPT style " Define style
<style type="text/css" media="all">
pre { text-align: left; padding: 10px;margin-left: 20px; color: black; }
pre.command {background-color: lightgrey;}
pre.cfg {background-color: lightblue;}
pre.code {background-color: lightpink;}
pre.output {background-color: lightgreen;}
</style> `cursor^

XPT command " command style
<pre class="command">
`content^
</pre>`cursor^

XPT cfg " cfg style
<pre class="cfg">
`content^
</pre>`cursor^

XPT code " code style
<pre class="code">
`content^
</pre>`cursor^

XPT output " output style
<pre class="output">
`content^
</pre>`cursor^
