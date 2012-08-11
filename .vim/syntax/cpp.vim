" Vim syntax file
" Language:	C++ special highlighting for STL classes and methods
" Maintainer:	Nathan Skvirsky
" Last Change:	2006 Oct 22

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Read the C syntax to start with
if version < 600
  so <sfile>:p:h/c.vim
else
  runtime! syntax/c.vim
  unlet b:current_syntax
endif

" C++ extentions

syn keyword cppSTL		abort abs accumulate acos adjacent_difference adjacent_find adjacent_find_if any append asctime asin assert assign at atan atan2 atexit atof atoi atol back back_inserter bad bad_alloc bad_cast bad_exception bad_typeid badbit beg begin binary_search bind2nd bsearch c_str calloc capacity ceil cerr cin clear clearerr clock clog close compare compose1 compose2 construct copy copy_backward copy_n cos cosh count count_if cout ctime data destroy difference_type difftime div domain_error empty end endl eof eofbit equal equal_range erase exception exit exp fabs fail failbit failure fclose feof ferror fflush fgetc fgetpos fgets fill fill_n find find_end find_first_not_of find_first_of find_if find_last_not_of find_last_of first flags flip floor flush fmod fopen for_each fprintf fputc fputs fread free freopen frexp front fscanf fseek fsetpos ftell fwrite gcount generate generate_n get get_temporary_buffer getc getchar getenv getline gets gmtime good goodbit greater greater_equal ignore in includes inner_product inplace_merge insert inserter invalid_argument ios ios_base iostate iota is_heap is_open is_sorted isalnum isalpha iscntrl isdigit isgraph islower isprint ispunct isspace istream isupper isxdigit iter_swap iterator_category key_comp ldiv length length_error less less_equal lexicographical_compare lexicographical_compare_3way localtime log log10 logic_error logical_and logical_not logical_or longjmp lower_bound make_heap malloc max max_element max_size mem_fun mem_fun1 mem_fun1_ref mem_fun_ref memchr memcpy memmove memset merge min min_element minus mismatch mktime modf modulus multiplies negate next_permutation npos nth_element numeric_limits open out_of_range overflow_error partial_sort partial_sort_copy partial_sum partition peek perror plus pop pop_back pop_front pop_heap pow power precision prev_permutation printf ptr_fun push push_back push_front push_heap put putback putc putchar puts qsort raise rand random_sample random_sample_n random_shuffle range_error rbegin rdbuf rdstate read realloc reference remove remove_copy remove_copy_if remove_if rename rend replace replace_copy replace_copy_if replace_if reserve reset resize return_temporary_buffer reverse reverse_copy rewind rfind rotate rotate_copy runtime_error scanf search search_n second seekg seekp set_difference set_intersection set_symmetric_difference set_union setbuf setf setjmp setlocale setvbuf signal sin sinh size size_t size_type sort sort_heap splice sprintf sqrt srand sscanf stable_partition stable_sort str strcat strchr strcmp strcoll strcpy strcspn strerror strftime strlen strncat strncmp strncpy strpbrk strrchr strspn strstr strtod strtok strtol strtoul strxfrm substr swap swap_ranges sync_with_stdio system tan tanh tellg tellp test time time_t tmpfile tmpnam to_string to_ulong tolower top toupper transform underflow_error unget ungetc uninitialized_copy uninitialized_copy_n uninitialized_fill uninitialized_fill_n unique unique_copy unsetf upper_bound va_arg value_comp value_type vfprintf vprintf vsprintf width write


syn keyword cppSTLtype		istreambuf_iterator filebuf string ofstream ifstream stream istringstream ostream ostream_iterator ostringstream fstream auto_ptr pointer pointer_to_binary_function pointer_to_unary_function basic_string bit_vector bitset char_producer deque hash hash_map hash_multimap hash_multiset hash_set list map multimap multiset queue priority_queue rope set stack vector back_insert_iterator iterator bidirectional_iterator bidirectional_iterator_tag forward_iterator forward_iterator_tag front_insert_iterator input_iterator input_iterator_tag insert_iterator istream_iterator iterator_traits output_iterator output_iterator_tag random_access_iterator random_access_iterator_tag raw_storage_iterator reverse_bidirectional_iterator reverse_iterator sequence_buffer binary_compose binary_function binary_negate binder1st binder2nd divides equal_to unary_compose unary_function unary_negate pair char_traits const_iterator temporary_buffer 

syn keyword cppStatement	new delete this friend using
syn keyword cppAccess		public protected private
syn keyword cppNamespace        std boost
syn keyword cppType		inline virtual explicit export bool wchar_t
syn keyword cppExceptions	throw try catch
syn keyword cppOperator		operator typeid
syn keyword cppOperator		and bitor or xor compl bitand and_eq or_eq xor_eq not not_eq
syn match cppCast		"\<\(const\|static\|dynamic\|reinterpret\)_cast\s*<"me=e-1
syn match cppCast		"\<\(const\|static\|dynamic\|reinterpret\)_cast\s*$"
syn keyword cppStorageClass	mutable
syn keyword cppStructure	class typename template namespace
syn keyword cppNumber		NPOS
syn keyword cppBoolean		true false

" The minimum and maximum operators in GNU C++
syn match cppMinMax "[<>]?"

" Default highlighting
if version >= 508 || !exists("did_cpp_syntax_inits")
  if version < 508
    let did_cpp_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink cppAccess		cppStatement
  HiLink cppCast		cppStatement
  HiLink cppExceptions		Exception
  HiLink cppOperator		Operator
  HiLink cppStatement		Statement
  HiLink cppSTL			Identifier
  HiLink cppNCBI		Special
  HiLink cppType		Type
  HiLink cppSTLtype             Type
  HiLink cppStorageClass	StorageClass
  HiLink cppStructure		Structure
  HiLink cppNumber		Number
  HiLink cppBoolean		Boolean
  HiLink cppNamespace           Macro
  delcommand HiLink
endif

let b:current_syntax = "cpp"

" vim: ts=8

