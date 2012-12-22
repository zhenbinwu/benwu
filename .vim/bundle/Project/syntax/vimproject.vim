syntax match projectDescriptionDir '^\s*.\{-}=\s*\(\\ \|\f\|:\|"\)\+' contains=projectDescription,projectWhiteError
syntax match projectDescription    '\<.\{-}='he=e-1,me=e-1         contained nextgroup=projectDirectory contains=projectWhiteError
syntax match projectDescription    '{\|}'
syntax match projectDirectory      '=\(\\ \|\f\|:\)\+'             contained
syntax match projectDirectory      '=".\{-}"'                      contained
syntax match projectScriptinout    '\<in\s*=\s*\(\\ \|\f\|:\|"\)\+' contains=projectDescription,projectWhiteError
syntax match projectScriptinout    '\<out\s*=\s*\(\\ \|\f\|:\|"\)\+' contains=projectDescription,projectWhiteError
syntax match projectComment        '#.*'
syntax match projectCD             '\<CD\s*=\s*\(\\ \|\f\|:\|"\)\+' contains=projectDescription,projectWhiteError
syntax match projectFilterEntry    '\<filter\s*=.*"'               contains=projectWhiteError,projectFilterError,projectFilter,projectFilterRegexp
syntax match projectFilter         '\<filter='he=e-1,me=e-1        contained nextgroup=projectFilterRegexp,projectFilterError,projectWhiteError
syntax match projectFlagsEntry     '\<flags\s*=\( \|[^ ]*\)'       contains=projectFlags,projectWhiteError
syntax match projectFlags          '\<flags'                       contained nextgroup=projectFlagsValues,projectWhiteError
syntax match projectFlagsValues    '=[^ ]* 'hs=s+1,me=e-1          contained contains=projectFlagsError
syntax match projectFlagsError     '[^rtTsSwl= ]\+'                contained
syntax match projectWhiteError     '=\s\+'hs=s+1                   contained
syntax match projectWhiteError     '\s\+='he=e-1                   contained
syntax match projectFilterError    '=[^"]'hs=s+1                   contained
syntax match projectFilterRegexp   '=".*"'hs=s+1                   contained
syntax match projectFoldText       '^[^=]\+{'
syntax match projectSource         '^\s*\<\w*\.\(C\|cpp\|cc\|vim\|py\)\>'

highlight def link projectDescription  Identifier
highlight def link projectScriptinout  Identifier
highlight def link projectFoldText     Identifier
highlight def link projectComment      Comment
highlight def link projectFilter       Identifier
highlight def link projectFlags        Identifier
highlight def link projectDirectory    Constant
highlight def link projectFilterRegexp String
highlight def link projectFlagsValues  String
highlight def link projectWhiteError   Error
highlight def link projectFlagsError   Error
highlight def link projectFilterError  Error
highlight def link projectSource       Label
