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

XPT class hint=Class\ declaration
//
// Class: `fileRoot()^
// Author: `$author^ (`$email^)
//
// Copyright (c) `year()^ `$author^
//

/**
 * @brief `briefDescription^
 */
class `fileRoot()^
{
public:
    `fileRoot()^(`argument^`...^, `arg^`...^);
    virtual ~`fileRoot()^();
    `cursor^
};
..XPT

XPT hfun hint=Member\ function\ declaration
/**
 * `functionName^
 *
 * `cursor^
 */
`int^ `functionName^(`argument^`...^, `arg^`...^)` const^;
..XPT

XPT css hint=const\ std::string&
const std::string& `cursor^
..XPT

XPT ft wrap " for (iterator = begin; !=;++)
for(`type^::iterator `i^=`class^.begin(); `i^!=`class^.end(); `i^++)
{
    `cursor^
}
