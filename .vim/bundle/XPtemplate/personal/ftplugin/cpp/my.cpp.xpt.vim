XPTemplate priority=personal

if exists("b:__MY_CPP_XPT_VIM__")
  finish
endif
let b:__MY_CPP_XPT_VIM__ = 1

let s:f = g:XPTfuncs()

function! s:f.endofHandler(...)
  let cline = getpos('.')[1]
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

XPT fs wrap " for (unsigned = 0; < size;++)
for(unsigned int `i^=0; `i^ < `class^`opt^size(); `i^++)
{
    `type^ `var^ = `class^`opt^at(`i^);
    `cursor^
}

XPT handler hint=CMSSW\ Handler
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ `beginHandler()^ ~~~~~
edm::InputTag `CMSObject^Tag_;
edm::Handle<`CMSObjectCollection^>  `CMSObject^Hdl;
CMSObjectTag_ = iConfig.getParameter<edm::InputTag>("`CMSObject^Tag");
iEvent.getByLabel(`CMSObject^Tag_, `CMSObject^Hdl); 
//`CMSObject^Tag = cms.InputTag("<+tagname+>"),
`...^
edm::InputTag `CMSObject^Tag_;
edm::Handle<`CMSObjectCollection^>  `CMSObject^Hdl;
CMSObjectTag_ = iConfig.getParameter<edm::InputTag>("`CMSObject^Tag");
iEvent.getByLabel(`CMSObject^Tag_, `CMSObject^Hdl); 
//`CMSObject^Tag = cms.InputTag("<+tagname+>"), 
`...^
XSET Handler|post=endofHandler()
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ End of `Handler^ ~~~~~
..XPT

