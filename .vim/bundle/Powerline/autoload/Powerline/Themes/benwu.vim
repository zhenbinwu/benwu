let g:Powerline#Themes#benwu#theme = Pl#Theme#Create(
	\ Pl#Theme#Buffer(''
		\ , 'paste_indicator'
		\ , 'mode_indicator'
		\ , 'fugitive:clean_branch'
        \ , 'fugitive:dirty_branch'
		\ , 'vimim'
		\ , 'hgrev:branch'
		\ , 'fileinfo'
		\ , 'syntastic:errors'
		\ , Pl#Segment#Truncate()
		\ , 'tagbar:fullcurrenttag'
		\ , Pl#Segment#Split()
		\ , 'rvm:string'
		\ , 'virtualenv:statusline'
		\ , 'filetype'
		\ , 'scrollpercent'
		\ , 'lineinfo'
		\ , 'syntastic:enable'
	\ ),
	\
	\ Pl#Theme#Buffer('command_t'
		\ , ['static_str.name', 'Command-T']
		\ , Pl#Segment#Truncate()
		\ , Pl#Segment#Split()
		\ , ['raw.line', '%10(Match #%l%)']
	\ ),
	\
	\ Pl#Theme#Buffer('gundo', Pl#Match#Any('gundo_tree')
		\ , ['static_str.name', 'Gundo']
		\ , ['static_str.buffer', 'Undo tree']
		\ , Pl#Segment#Truncate()
		\ , Pl#Segment#Split()
	\ ),
	\
	\ Pl#Theme#Buffer('gundo', Pl#Match#Any('gundo_preview')
		\ , ['static_str.name', 'Gundo']
		\ , ['static_str.buffer', 'Diff preview']
		\ , Pl#Segment#Truncate()
		\ , Pl#Segment#Split()
	\ ),
    \
	\ Pl#Theme#Buffer('bufexplorer', Pl#Match#Any('bufexplorer')
		\ , ['static_str.name', 'BufExplorer']
		\ , Pl#Segment#Truncate()
		\ , Pl#Segment#Split()
	\ ),
	\
	\ Pl#Theme#Buffer('taglist', Pl#Match#Any('taglist')
		\ , ['static_str.name', 'TagList']
		\ , Pl#Segment#Truncate()
		\ , Pl#Segment#Split()
	\ ),
	\
	\ Pl#Theme#Buffer('bt_help'
		\ , ['static_str.name', 'Help']
		\ , 'filename'
		\ , Pl#Segment#Truncate()
		\ , Pl#Segment#Split()
		\ , 'scrollpercent'
	\ ),
	\
	\ Pl#Theme#Buffer('ft_vimpager'
		\ , ['static_str.name', 'Pager']
		\ , 'filename'
		\ , Pl#Segment#Truncate()
		\ , Pl#Segment#Split()
		\ , 'scrollpercent'
	\ ),
	\
	\ Pl#Theme#Buffer('lustyexplorer'
		\ , ['static_str.name', 'LustyExplorer']
		\ , ['static_str.buffer', 'Buffer list']
		\ , Pl#Segment#Truncate()
		\ , Pl#Segment#Split()
	\ ),
	\
	\ Pl#Theme#Buffer('ft_man'
		\ , ['static_str.name', 'Man page']
		\ , 'filename'
		\ , Pl#Segment#Truncate()
		\ , Pl#Segment#Split()
		\ , 'scrollpercent'
	\ ),
	\
	\ Pl#Theme#Buffer('minibufexplorer'
		\ , ['static_str.name', 'MiniBufExplorer']
		\ , Pl#Segment#Truncate()
		\ , Pl#Segment#Split()
	\ ),
	\
    \ Pl#Theme#Buffer('ft_qf'
		\ , 'filename'
        \ , Pl#Segment#Truncate()
		\ , Pl#Segment#Split()
        \ , 'qfdone'
    \ ),
    \
	\ Pl#Theme#Buffer('tagbar'
		\ , ['static_str.name', 'Tagbar']
		\ , ['static_str.buffer', 'Tree']
		\ , Pl#Segment#Truncate()
		\ , Pl#Segment#Split()
	\ ),
	\
	\ Pl#Theme#Buffer('ctrlp', Pl#Theme#Callback('ctrlp_main', 'if ! exists("g:ctrlp_status_func") | let g:ctrlp_status_func = {} | endif | let g:ctrlp_status_func.main = "%s"')
		\ , 'ctrlp:prev'
		\ , 'ctrlp:item'
		\ , 'ctrlp:next'
		\ , 'ctrlp:marked'
		\ , Pl#Segment#Truncate()
		\ , Pl#Segment#Split()
		\ , 'ctrlp:focus'
		\ , 'ctrlp:byfname'
		\ , 'pwd'
	\ ),
	\
	\ Pl#Theme#Buffer('ctrlp', Pl#Theme#Callback('ctrlp_prog', 'if ! exists("g:ctrlp_status_func") | let g:ctrlp_status_func = {} | endif | let g:ctrlp_status_func.prog = "%s"')
		\ , 'ctrlp:count'
		\ , Pl#Segment#Truncate()
		\ , Pl#Segment#Split()
		\ , 'pwd'
	\ ),
	\
	\ Pl#Theme#Buffer('nerdtree'
		\ , ['static_str.name', 'NERDTree']
		\ , Pl#Segment#Truncate()
		\ , Pl#Segment#Split()
	\ ),
	\
	\ Pl#Theme#Buffer('conqueterm'
		\ , ['static_str.name', 'Conque_Term']
		\ , 'conqueterm:statusline'
		\ , Pl#Segment#Truncate()
		\ , Pl#Segment#Split()
	\ ),
	\
	\ Pl#Theme#Buffer('calendar'
		\ , ['static_str.name', 'Calendar']
        \ , 'calendar:datetime'
		\ , Pl#Segment#Truncate()
		\ , Pl#Segment#Split()
	\ ),
    \
	\ Pl#Theme#Buffer('project'
		\ , 'project:project'
		\ , 'project:projectN'
		\ , 'filemod'
		\ , Pl#Segment#Truncate()
		\ , Pl#Segment#Split()
	\ ), 
    \
	\ Pl#Theme#Buffer('cctree'
		\ , 'cctree_title'
		\ , 'cctree_depth'
		\ , Pl#Segment#Truncate()
		\ , Pl#Segment#Split()
	\ )
\ )
