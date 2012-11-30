let g:Powerline#Segments#conqueterm#segments = Pl#Segment#Init(['conqueterm',
	\ has('python') && (exists('g:ConqueTerm_Loaded') && g:ConqueTerm_Loaded == 1),
	\
	\ Pl#Segment#Create('statusline', '%{conque_term#powerline()}'),
\ ])
