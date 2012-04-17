" This is trying to fix the error hightlight of underscore in tex
" Even though it is generally permitted only in math mode in latex,
" I use it alot in directory and file name
" clear the curent list of matches that cause error-highlighting
syn clear texOnlyMath
" still mark '^' as an error outside of math mode
syn match texOnlyMath /[\^]/
