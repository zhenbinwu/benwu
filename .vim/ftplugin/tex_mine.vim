" this is mostly a matter of taste. but LaTeX looks good with just a bit
" of indentation.
set sw=2
" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
set iskeyword+=:

""By default, typing Alt-<key> in Vim takes focus to the menu bar if a menu
""with the hotkey <key> exists. If in your case, there are conflicts due to
""this behavior, you will need to set  >
set winaltkeys=no

""The Alt key is hard to map within Xterm. So I have to re-map other key 
imap <C-L> <Plug>Tex_LeftRight
imap <C-B> <Plug>Tex_MathBF
imap <C-D> <Plug>Tex_MathCal
imap <C-U> <Plug>Tex_InsertItemOnThisLine

"" imap .<CR> <C-R>set b:Imap_FreezeImap=1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Some IMAP for HEP 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call IMAP(' wbb', ' $Wb\bar{b}$', 'tex')
call IMAP(' wcc', ' $Wc\bar{c}$', 'tex')
call IMAP(' ttbar', ' $t\bar{t}$', 'tex')
