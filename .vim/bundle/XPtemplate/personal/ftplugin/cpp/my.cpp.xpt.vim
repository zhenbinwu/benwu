XPTemplate priority=personal

if exists("b:__MY_CPP_XPT_VIM__")
  finish
endif
let b:__MY_CPP_XPT_VIM__ = 1

let s:f = g:XPTfuncs()

function! s:f.endofHandler(...)
  let cline = getpos('.')[1]
  let cline = eval(cline -1)
  exe cline.", ".cline."d"
  exe s:hdlcline. ", " . cline."g/iConfig.getParameter/m".cline
  exe s:hdlcline. ", " . cline."g/iEvent.getByLabel/m".cline
  exe s:hdlcline. ", " . cline."g/cms.InputTag/m".cline
  return ""
endfunction

function! s:f.beginHandler(...)
  let s:hdlcline = getpos('.')[1]
  return "Begin Handler"
endfunction

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
`const ^std::shared_ptr<`type^> `cursor^
..XPT

XPT wp hint=Weak\ pointer\ usage
`const ^std::weak_ptr<`type^> `cursor^
..XPT

XPT up hint=Unique\ pointer\ usage
`const ^std::unique_ptr<`type^> `cursor^
..XPT

XPT ss hint=stringstream
`const ^std::stringstream `cursor^
..XPT

XPT css hint=const\ std::string&
const std::string& `cursor^
..XPT

XPT ft wrap " for (iterator = begin; !=;++)
for(`type^::const_iterator `i^=`class^.begin();
    `i^!=`class^.end(); ++`i^)
{
    `cursor^
}

XPT fu hint=function\ definition
XSET class|post=S(V(), '.*[^:]', '&::', '')
// ===  FUNCTION  ============================================================
//         Name:  `class^`name^
//  Description:  `cursor^
// ===========================================================================
`bool^ `class^`name^(`param^`...^, `param^`...^)` const^
{
    <+CURSOR+>
    return `true^;
}       // -----  end of function `class^`name^  -----

XPT << hint=<<""
<< "`content^" `cursor^
..XPT

XPT bf wrap " BOOST_FOREACH
BOOST_FOREACH(`content^, `sequence^)
{
    `cursor^
}

XPT fa wrap " for (auto : class)
for(auto `i^ : `class^)
{
    `cursor^
}

XPT fs wrap " for (unsigned = 0; < size;++)
for(unsigned int `i^=0; `i^ < `class^`opt^size(); ++`i^)
{
    `type^ `var^ = `class^`opt^at(`i^);
    `cursor^
}

XPT handler hint=CMSSW\ Handler
XSET Handler|post=endofHandler()
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ `beginHandler()^ ~~~~~
edm::InputTag `CMSObject^Tag_;
edm::Handle<`CMSObjectCollection^>  `CMSObject^Hdl;
`CMSObject^Tag_ = iConfig.getParameter<edm::InputTag>("`CMSObject^Tag");
iEvent.getByLabel(`CMSObject^Tag_, `CMSObject^Hdl); 
//`CMSObject^Tag = cms.InputTag("<+tagname+>"),
`...^
edm::InputTag `CMSObject^Tag_;
edm::Handle<`CMSObjectCollection^>  `CMSObject^Hdl;
`CMSObject^Tag_ = iConfig.getParameter<edm::InputTag>("`CMSObject^Tag");
iEvent.getByLabel(`CMSObject^Tag_, `CMSObject^Hdl); 
//`CMSObject^Tag = cms.InputTag("<+tagname+>"), 
`...^
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ End of `Handler^ ~~~~~
..XPT

