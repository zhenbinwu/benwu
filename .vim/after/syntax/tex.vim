" This is trying to fix the error hightlight of underscore in tex
" Even though it is generally permitted only in math mode in latex,
" I use it alot in directory and file name
" clear the curent list of matches that cause error-highlighting
syn clear texOnlyMath
" still mark '^' as an error outside of math mode
syn match texOnlyMath /[\^]/

" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
"
" When using tags jumpping around files, iskeyword can be reset by default
" syntax/tex.vim. Thus it need to move to here. 
setlocal iskeyword+=:
setlocal iskeyword+=_
