let g:Powerline#Segments#fugitive#segments = Pl#Segment#Init(['fugitive',
	\ (exists('g:loaded_fugitive') && g:loaded_fugitive == 1),
	\
	\ Pl#Segment#Create('clean_branch', '%{Powerline#Functions#fugitive#GetCleanBranch("$BRANCH")}'),
	\ Pl#Segment#Create('dirty_branch', '%{Powerline#Functions#fugitive#GetDirtyBranch("$BRANCH")}')
\ ])
