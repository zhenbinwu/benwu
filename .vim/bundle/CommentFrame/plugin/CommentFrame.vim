"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Commands, Mappings of Custom Functions {{{ ~~~~~
command! -nargs=+ CommentFrameCustom :call CommentFrame#Custom(<args>)
call CommentFrame#MapKeys("ni", "cf", ":CommentFrameCustom '#','#',78,'=','-',3,''<Left>")


command! -nargs=+ CommentRightCustom :call CommentFrame#CustomRight(<args>)
call CommentFrame#MapKeys("ni", "cr", ":CommentRightCustom '#','',78,5,'~',1,''<Left>")

"}}}

""~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Languages, CommentFrame {{{ ~~~~~
command! -nargs=+ CommentFrameSlashes     : call CommentFrame#Custom('//', '//', 78, '*', ' ', 0, <args>)
autocmd FileType cpp call CommentFrame#MapLocalKeys('ni', 'cf', ':CommentFrameSlashes ""<Left>')

command! -nargs=+ CommentFrameSlashStar   : call CommentFrame#Custom('/*', '*/', 78, '*', ' ', 0, <args>)
autocmd FileType c call CommentFrame#MapLocalKeys('ni', 'cf', ':CommentFrameSlashStar ""<Left>')

command! -nargs=+ CommentFrameHashDash    : call CommentFrame#Custom('#', '#', 78, '-', ' ', 0, <args>)
autocmd FileType sh call CommentFrame#MapLocalKeys('ni', 'cf', ':CommentFrameHashDash ""<Left>')

command! -nargs=+ CommentFrameHashEqual   : call CommentFrame#Custom('#', '#', 78, '=', '-', 5, <args>)
autocmd FileType csh call CommentFrame#MapLocalKeys('ni', 'cf', ':CommentFrameHashEqual ""<Left>')

command! -nargs=+ CommentFrameQuoteDash   : call CommentFrame#Custom('"', '"', 78, '=', ' ', 5, <args>)
autocmd FileType vim call CommentFrame#MapLocalKeys('ni', 'cf', ':CommentFrameQuoteDash ""<Left>')

"command! -nargs=+ CommentFrameQuoteTilde  : call CommentFrame#Custom('"', '"', 78, '~', ' ', 5, <args>)
"call CommentFrame#MapLocalKeys('ni', 'cfQ', ':CommentFrameQuoteTilde ""<Left>')

""}}}

""~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Languages, CommentRight {{{ ~~~~~
command! -nargs=+ CommentRightSlashes   : call CommentFrame#CustomRight('//', '', 78, 5, '~', 1, <args>)
autocmd FileType cpp call CommentFrame#MapLocalKeys('ni', 'cr', ':CommentRightSlashes ""<Left>')

command! -nargs=+ CommentRightSlashStar : call CommentFrame#CustomRight('/*', '*/', 78, 5, '~', 1, <args>)
autocmd FileType c call CommentFrame#MapLocalKeys('ni', 'cr', ':CommentRightSlashStar ""<Left>')

command! -nargs=+ CommentRightHash      : call CommentFrame#CustomRight('#', '', 78, 5, '~', 1, <args>)
autocmd FileType sh     call  CommentFrame#MapLocalKeys('ni', 'cr', ':CommentRightHash ""<Left>')
autocmd FileType csh    call  CommentFrame#MapLocalKeys('ni', 'cr', ':CommentRightHash ""<Left>')
autocmd FileType python call  CommentFrame#MapLocalKeys('ni', 'cr', ':CommentRightHash ""<Left>')

command! -nargs=+ CommentRightQuote     : call CommentFrame#CustomRight('"', '', 78, 5, '~', 1, <args>)
autocmd FileType vim call CommentFrame#MapLocalKeys('ni', 'cr', ':CommentRightQuote ""<Left>')

