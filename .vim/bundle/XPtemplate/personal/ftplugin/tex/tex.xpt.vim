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
\includegraphics[width=`0.9^\textwidth, keepaspectratio]{`content^}<++>


XPT tikzpicture " \begin{tikzpicture}{..} .. \end{tikzpicture}
\begin{tikzpicture}
    \node[anchor=south west,inner sep=0] (image) at (0,0) {\includegraphics[width=`0.9^\textwidth]{`content^}};
    \begin{scope}[x={(image.south east)},y={(image.north west)}]
      \draw[help lines,xstep=.1,ystep=.1] (0,0) grid (1,1);
      \foreach \x in {0,1,...,9} { \node [anchor=north] at (\x/10,0) {0.\x}; }
      \foreach \y in {0,1,...,9} { \node [anchor=east] at (0,\y/10) {0.\y}; }
      \draw[red,ultra thick,rounded corners] (0.15,0.10) rectangle (0.20,0.95);
    \end{scope}
\end{tikzpicture}
 
"XPT documentclass " documentclass[..]{..}
"XSET kind=Choose(['article','book','report', 'letter','slides'])
"\documentclass[`size~11~pt]{`kind~}
"..XPT


"XPT usepackage " usepackage{..}
"\usepackage{`cursor^}<++>
"..XPT

XPT r " ref{..}
\ref{`cursor^}<++>
..XPT

XPT rf " ref{..}
\ref{fig:`cursor^}<++>
..XPT

XPT srf " ref{..}
\subref{fig:`cursor^}<++>
..XPT

XPT rs " ref{..}
\ref{s:`cursor^}<++>
..XPT

XPT rss " ref{..}
\ref{ss:`cursor^}<++>
..XPT

XPT rq " ref{..}
\ref{eq:`cursor^}<++>
..XPT

XPT rt " ref{..}
\ref{tab:`cursor^}<++>
..XPT

XPT underline " \underline{text}
\ul{`cursor^}<++>
..XPT

XPT subfigure " \subfigure
\subfigure[]{
\includegraphics[width=`0.9^\textwidth, keepaspectratio]{`content^}
\label{fig:`cursor^}
}<++>


