XPTemplate priority=lang mark=~^

let s:f = g:XPTfuncs()

XPTvar $TRUE          1
XPTvar $FALSE         0
XPTvar $NULL          NULL
XPTvar $UNDEFINED     NULL

XPTvar $VOID_LINE     # void
XPTvar $CURSOR_PH     # cursor


XPTvar $BRif          ' '
XPTvar $BRel          \n
XPTvar $BRloop        ' '
XPTvar $BRstc         ' '
XPTvar $BRfun         ' '

XPTvar $SPop          ''
XPTvar $SParg         ''

XPTinclude
      \ _common/common
      \ _printf/c.like

XPTvar $CS    #
XPTinclude
      \ _comment/singleSign


" ========================= Function and Variables =============================

let s:braceMap = {
            \   '`' : '`',
            \   '{' : '}',
            \   '[' : ']',
            \   '(' : ')',
            \  '{{' : '}}',
            \  '[[' : ']]',
            \  '((' : '))',
            \  '{ ' : ' }',
            \  '[ ' : ' ]',
            \  '( ' : ' )',
            \ '{{ ' : ' }}',
            \ '[[ ' : ' ]]',
            \ '(( ' : ' ))',
            \}

fun! s:f.sh_complete_brace()

    let v = self.V()
    let br = matchstr( v, '\V\^\[\[({`]\{1,2} \?' )
    if br == ''
        return ''
    elseif br == '`'
        return s:braceMap[ br ]
    else
        try
            let cmpl = s:braceMap[ br ]
            let cmplEsc = substitute( cmpl, ']', '\\[]]', 'g' )
            let tail = matchstr( v, '\V\%[' . cmplEsc . ']\$' )
            if tail == ' ' && br =~ ' '
                let tail = ''
            endif
            return cmpl[ len( tail ) : ]
        catch /.*/
            echom v:exception
        endtry
    endif

endfunction

" ================================= Snippets ===================================




XPT shebang " #!/bin/[ba|z|c]sh
XSET sh=ChooseStr( 'sh', 'tcsh', 'zsh', 'csh' )
#!/bin/~sh^

..XPT

XPT sb alias=shebang

XPT _shebang hidden " #!/bin/$_xSnipName
#!/bin/~$_xSnipName^

..XPT


XPT sh   alias=_shebang
XPT tcsh alias=_shebang
XPT zsh  alias=_shebang
XPT csh  alias=_shebang


XPT echodate " echo `date +%...`
echo `date~ +~fmt^`

XPT _cond hidden
XSET condition|map=[ [
XSET condition|map=( (
~condition^~condition^sh_complete_brace()^


XPT printf	" printf\(...)
XSET elts|pre=Echo('')
XSET elts=c_printf_elts( R( 'pattern' ), ' '[ len( $SPop ) : ] )
printf "~pattern^"~elts^

XPT for wrap " foreach each (); end
foreach ~i^ (~list^)
    ~cursor^
end


XPT while wrap " while ..; do
while (~:_cond:^)
    ~cursor^
end


XPT while1 alias=while " while [ 1 ]; do
XSET condition=Next( ' ~$TRUE^ ' )

XPT case wrap " case .. in ..
case ~$~var^ in
    ~pattern^)
    ~cursor^
    ;;

esac

XPT if wrap " if ..; then
if (~:_cond:^)~$BRif^then
    ~cursor^
endif

XPT else wrap " else ..
else
    ~cursor^

XPT ife wrap=job " if ..; then .. else ..
if (~:_cond:^)~$BRif^then
    ~job^
else
    ~cursor^
endif

XPT elif wrap " elif .. ; then
elif (~:_cond:^)~$BRif^then
    ~cursor^

XPT fun wrap " .. () { .. }
~name^ ()~$BRfun^{
    ~cursor^
}

"" Not so sure yet

XPT here wrap " << END ..
<<~-~END^
~cursor^
~END^substitute( V(), '\v\^-', '', '' )^

XPT until wrap " until ..; do
until ~:_cond:^;~$BRloop^;do
    ~cursor^
done
