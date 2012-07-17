if exists('g:loaded_textobj_pair')
  finish
endif

call textobj#user#plugin('underscore', {
\      '-': {
\        '*sfile*': expand('<sfile>:p'),
\        'select-a': 'a_',  '*select-a-function*': 'textobj#pair#select_underscore_a',
\        'select-i': 'i_',  '*select-i-function*': 'textobj#pair#select_underscore_i'
\      }
\    })

call textobj#user#plugin('dollar', {
\      '4': {
\        '*sfile*': expand('<sfile>:p'),
\        'select-a': 'a4',  '*select-a-function*': 'textobj#pair#select_dollar_a',
\        'select-i': 'i4',  '*select-i-function*': 'textobj#pair#select_dollar_i',
\      },
\      '$': {
\        '*sfile*': expand('<sfile>:p'),
\        'select-a': 'a$',  '*select-a-function*': 'textobj#pair#select_dollar_a',
\        'select-i': 'i$',  '*select-i-function*': 'textobj#pair#select_dollar_i',
\      },
\    })

call textobj#user#plugin('pound', {
\      '3': {
\        '*sfile*': expand('<sfile>:p'),
\        'select-a': 'a3',  '*select-a-function*': 'textobj#pair#select_pound_a',
\        'select-i': 'i3',  '*select-i-function*': 'textobj#pair#select_pound_i',
\      },
\      '#': {
\        '*sfile*': expand('<sfile>:p'),
\        'select-a': 'a#',  '*select-a-function*': 'textobj#pair#select_pound_a',
\        'select-i': 'i#',  '*select-i-function*': 'textobj#pair#select_pound_i',
\      },
\    })

let g:loaded_textobj_pair = 1

