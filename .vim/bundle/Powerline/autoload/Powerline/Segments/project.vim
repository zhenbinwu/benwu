let g:Powerline#Segments#project#segments = Pl#Segment#Init(['project',
	\ (exists('loaded_project') && loaded_project == 1),
	\
	\ Pl#Segment#Create('project', '%{Powerline#Functions#project#GetProject()}', Pl#Segment#Modes('!N')),
    \ Pl#Segment#Create('projectN', '%{g:project_powerline}', Pl#Segment#Modes('N'))
\ ])
