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


XPT code wrap=content hint=[code]...[/code]
[code] 
`content^
[/code]

XPT table wrap=content hint=[table]...[/table]
[table border="1"] 
`content^
[/table]

XPT quote wrap=content hint=[quote]...[/quote]
[quote] 
`content^
[/quote]

XPT list wrap=content hint=[list]...[/list]
[list] 
[*] `content^ 
`...^[*] `content^
`...^
[/list]

XPT mimg wrap=content hint=[img]...[/img]
[img]elog:/`content^[/img]

XPT u wrap=content hint=[u]...[/u]
[u]`content^[/u]

XPT b wrap=content hint=[b]...[/b]
[b]`content^[/b]

XPT i wrap=content hint=[i]...[/i]
[i]`content^[/i]

XPT elog " elog i
[url=http://hep.baylor.edu/elog/benwu/`i^]elog:`i^[/url]

XPT color wrap=content hint=[color]...[/color]
[color=`red^]`content^[/color]

XPT center wrap=content hint=[center]...[/center]
[center]`content^[/center]

XPT h1 wrap=content hint=[h1]...[/h1]
[h1]`content^[/h1]

XPT h2 wrap=content hint=[h2]...[/h2]
[h2]`content^[/h2]

XPT h3 wrap=content hint=[h3]...[/h3]
[h3]`content^[/h3]


XPT reply " reply to elog 
[quote="Ben Wu"]
[h2]In reply to [url=http://hep.baylor.edu/elog/benwu/`i^]elog:`i^[/url]:: `content^[/h2]
[/quote]

