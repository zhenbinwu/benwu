import re
import vim

def snippetsInit():
  vim.command("noremap <silent> <buffer> <tab> :python updateSnips()<CR>")
  vim.command("inoremap <silent> <buffer> <c-k> <ESC>:python updateSnips()<CR>")
  if int(vim.eval("g:clang_conceal_snippets")) == 1:
    vim.command("syntax match placeHolder /<#[^#]*#>/ contains=placeHolderMark")
    vim.command("syntax match placeHolderMark contained /<#/ conceal")
    vim.command("syntax match placeHolderMark contained /#>/ conceal")

# The two following function are performance sensitive, do _nothing_
# more that the strict necessary.

def snippetsFormatPlaceHolder(word):
  return "<#%s#>" % word

def snippetsAddSnippet(fullname, word, abbr):
  #return word
  if fullname == word:
    return word
  else:
    return "%s<##>" % word

r = re.compile('<#[^#]*#>')

def snippetsTrigger():
  if r.search(vim.current.line) is None:
    return None
  vim.command('call feedkeys("\<esc>^\<tab>")')

def snippetsReset():
  pass

def updateSnips():
  line = vim.current.line
  row, col = vim.current.window.cursor

  result = r.search(line, col)
  if result is None:
    result = r.search(line)
    if result is None:
      vim.command('call feedkeys("\<c-o>k", "n")')
      return None

  start, end = result.span()
  vim.current.window.cursor = row, start
  isInclusive = vim.eval("&selection") == "inclusive"
  if end - start - isInclusive == 3:
    vim.command('call feedkeys("\<ESC>v%dl\<C-G>o\<BS>", "n")' % (end - start - isInclusive))
  else:
    vim.command('call feedkeys("\<ESC>v%dl\<C-G>", "n")' % (end - start - isInclusive))

# vim: set ts=2 sts=2 sw=2 expandtab :
