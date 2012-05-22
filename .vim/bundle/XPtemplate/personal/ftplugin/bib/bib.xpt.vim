" Move me to your own fptlugin/_common and config your personal information.
"
" Here is the place to set personal preferences; "priority=personal" is the
" highest which overrides any other XPTvar setting.
"
" You can also set personal variables with 'g:xptemplate_vars' in your .vimrc.
XPTemplate priority=personal  

let s:f = g:XPTfuncs()

XPTvar $AUTHOR     Ben Wu
XPTvar $EMAIL      benwu@fnal.gov

XPTinclude
      \ _common/common

" ================================= Snippets ===================================


XPT bc " CDF Internal Note
@CDFNOTE{CDF`number^,
  author = "`cursor^",
  title = "<++>",
  year = "<++>",
  number = "`number^",
  otherinfo = "<++>"
}<++>

XPT bp " CDF Internal Note
@CDFPUB{CDF`number^,
  author = "`cursor^",
  title = "<++>",
  year = "<++>",
  number = "`number^",
  otherinfo = "<++>"
}<++>
