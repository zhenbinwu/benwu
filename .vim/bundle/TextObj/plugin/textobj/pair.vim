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
\      '-': {
\        '*sfile*': expand('<sfile>:p'),
\        'select-a': 'a$',  '*select-a-function*': 'textobj#pair#select_dollar_a',
\        'select-i': 'i$',  '*select-i-function*': 'textobj#pair#select_dollar_i'
\      }
\    })

call textobj#user#plugin('pound', {
\      '-': {
\        '*sfile*': expand('<sfile>:p'),
\        'select-a': 'a#',  '*select-a-function*': 'textobj#pair#select_pound_a',
\        'select-i': 'i#',  '*select-i-function*': 'textobj#pair#select_pound_i'
\      }
\    })

let g:loaded_textobj_pair = 1

