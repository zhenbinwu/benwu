XPTemplate priority=personal

if exists("b:__MY_CPP_XPT_VIM__")
  finish
endif
let b:__MY_CPP_XPT_VIM__ = 1


XPT try hint=Try/catch\ block
try
{
    `what^
}
catch (`Exception^& e...^)
{
    `handler^
}
`...^catch (`Exception^& e...^)
{
    `handler^
}`...^
..XPT

XPT sp hint=Smart\ pointer\ usage
`const ^std::tr1::shared_ptr<`type^>& `cursor^
..XPT

XPT css hint=const\ std::string&
const std::string& `cursor^
..XPT

XPT ft wrap " for (iterator = begin; !=;++)
for(`type^::iterator `i^=`class^.begin();
    `i^!=`class^.end(); `i^++)
{
    `cursor^
}

XPT fu hint=function\ definition
XSET class|post=S(V(), '.*[^:]', '&::', '')
// ===  FUNCTION  ============================================================
//         Name:  `class^`name^
//  Description:  `cursor^
// ===========================================================================
`int^ `class^`name^(`param^`...^, `param^`...^)` const^
{
    <+code+>
}       // -----  end of function `class^`name^  -----

XPT << hint=<<""
<< "`content^" `cursor^

XPT bf wrap " BOOST_FOREACH
BOOST_FOREACH(`content^, `sequence^)
{
    `cursor^
}

XPT fa wrap " for (auto = begin; !=;++)
for(auto `i^=`class^.begin(); `i^!=`class^.end(); `i^++)
{
    `cursor^
}
