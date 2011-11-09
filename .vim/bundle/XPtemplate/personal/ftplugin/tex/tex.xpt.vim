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

XPT graphics wrap=content hint=[color]...[/color]
\includegraphics[height=`0.3^\textheight, keepaspectratio]{`content^}<++>


XPT tikzpicture " \begin{tikzpicture}{..} .. \end{tikzpicture}
\begin{tikzpicture}
    `cursor^
\end{tikzpicture}
 
XPT documentclass " documentclass[..]{..}
XSET kind=Choose(['article','book','report', 'letter','slides'])
\documentclass[`size~11~pt]{`kind~}
..XPT


XPT usepackage " usepackage{..}
\usepackage{`cursor~}<++>
..XPT