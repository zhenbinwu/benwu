" Vim syntax file
" Language:	C++ special highlighting for STL classes and methods
" Maintainer:	Nathan Skvirsky
" Last Change:	2006 Oct 22

" For version 6.x: Quit when a syntax file was already loaded
if version < 600
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

syntax keyword cppSTLconstant badbit
syntax keyword cppSTLconstant digits
syntax keyword cppSTLconstant digits10
syntax keyword cppSTLconstant eofbit
syntax keyword cppSTLconstant failbit
syntax keyword cppSTLconstant goodbit
syntax keyword cppSTLconstant has_denorm
syntax keyword cppSTLconstant has_denorm_loss
syntax keyword cppSTLconstant has_infinity
syntax keyword cppSTLconstant has_quiet_NaN
syntax keyword cppSTLconstant has_signaling_NaN
syntax keyword cppSTLconstant is_bounded
syntax keyword cppSTLconstant is_exact
syntax keyword cppSTLconstant is_iec559
syntax keyword cppSTLconstant is_integer
syntax keyword cppSTLconstant is_modulo
syntax keyword cppSTLconstant is_signed
syntax keyword cppSTLconstant is_specialized
syntax keyword cppSTLconstant max_digits10
syntax keyword cppSTLconstant max_exponent
syntax keyword cppSTLconstant max_exponent10
syntax keyword cppSTLconstant min_exponent
syntax keyword cppSTLconstant min_exponent10
syntax keyword cppSTLconstant nothrow
syntax keyword cppSTLconstant npos
syntax keyword cppSTLconstant radix
syntax keyword cppSTLconstant round_style
syntax keyword cppSTLconstant tinyness_before
syntax keyword cppSTLconstant traps
syntax keyword cppSTLexception bad_alloc
syntax keyword cppSTLexception bad_array_new_length
syntax keyword cppSTLexception bad_exception
syntax keyword cppSTLexception bad_typeid bad_cast
syntax keyword cppSTLexception domain_error
syntax keyword cppSTLexception exception
syntax keyword cppSTLexception invalid_argument
syntax keyword cppSTLexception length_error
syntax keyword cppSTLexception logic_error
syntax keyword cppSTLexception out_of_range
syntax keyword cppSTLexception overflow_error
syntax keyword cppSTLexception range_error
syntax keyword cppSTLexception runtime_error
syntax keyword cppSTLexception underflow_error
syntax keyword cppSTLfunction abort
syntax keyword cppSTLfunction abs
syntax keyword cppSTLfunction accumulate
syntax keyword cppSTLfunction acos
syntax keyword cppSTLfunction adjacent_difference
syntax keyword cppSTLfunction adjacent_find
syntax keyword cppSTLfunction adjacent_find_if
syntax keyword cppSTLfunction advance
syntax keyword cppSTLfunctional binary_function
syntax keyword cppSTLfunctional binary_negate
syntax keyword cppSTLfunctional bit_and
syntax keyword cppSTLfunctional bit_not
syntax keyword cppSTLfunctional bit_or
syntax keyword cppSTLfunctional divides
syntax keyword cppSTLfunctional equal_to
syntax keyword cppSTLfunctional greater
syntax keyword cppSTLfunctional greater_equal
syntax keyword cppSTLfunctional less
syntax keyword cppSTLfunctional less_equal
syntax keyword cppSTLfunctional logical_and
syntax keyword cppSTLfunctional logical_not
syntax keyword cppSTLfunctional logical_or
syntax keyword cppSTLfunctional minus
syntax keyword cppSTLfunctional modulus
syntax keyword cppSTLfunctional multiplies
syntax keyword cppSTLfunctional negate
syntax keyword cppSTLfunctional not_equal_to
syntax keyword cppSTLfunctional plus
syntax keyword cppSTLfunctional unary_function
syntax keyword cppSTLfunctional unary_negate
"syntax keyword cppSTLfunction any "Avoid conflict with boost::any 
syntax keyword cppSTLfunction append
syntax keyword cppSTLfunction arg
syntax keyword cppSTLfunction asctime
syntax keyword cppSTLfunction asin
syntax keyword cppSTLfunction assert
syntax keyword cppSTLfunction assign
syntax keyword cppSTLfunction at
syntax keyword cppSTLfunction atan
syntax keyword cppSTLfunction atan2
syntax keyword cppSTLfunction atexit
syntax keyword cppSTLfunction atof
syntax keyword cppSTLfunction atoi
syntax keyword cppSTLfunction atol
syntax keyword cppSTLfunction back
syntax keyword cppSTLfunction back_inserter
syntax keyword cppSTLfunction bad
syntax keyword cppSTLfunction beg
syntax keyword cppSTLfunction begin
syntax keyword cppSTLfunction binary_compose
syntax keyword cppSTLfunction binary_negate
syntax keyword cppSTLfunction binary_search
syntax keyword cppSTLfunction bind1st
syntax keyword cppSTLfunction bind2nd
syntax keyword cppSTLfunction binder1st
syntax keyword cppSTLfunction binder2nd
syntax keyword cppSTLfunction bsearch
syntax keyword cppSTLfunction calloc
syntax keyword cppSTLfunction capacity
syntax keyword cppSTLfunction ceil
syntax keyword cppSTLfunction cerr
syntax keyword cppSTLfunction cin
syntax keyword cppSTLfunction clear
syntax keyword cppSTLfunction clearerr
syntax keyword cppSTLfunction clock
syntax keyword cppSTLfunction clog
syntax keyword cppSTLfunction close
syntax keyword cppSTLfunction compare
syntax keyword cppSTLfunction conj
syntax keyword cppSTLfunction construct
syntax keyword cppSTLfunction copy
syntax keyword cppSTLfunction copy_backward
syntax keyword cppSTLfunction cos
syntax keyword cppSTLfunction cosh
syntax keyword cppSTLfunction count
syntax keyword cppSTLfunction count_if
syntax keyword cppSTLfunction cout
syntax keyword cppSTLfunction c_str
syntax keyword cppSTLfunction ctime
"syntax keyword cppSTLfunction data "Commonly not a function 
syntax keyword cppSTLfunction denorm_min
syntax keyword cppSTLfunction destroy
syntax keyword cppSTLfunction difftime
syntax keyword cppSTLfunction distance
syntax keyword cppSTLfunction div
syntax keyword cppSTLfunction empty
syntax keyword cppSTLfunction end
syntax keyword cppSTLfunction eof
syntax keyword cppSTLfunction epsilon
syntax keyword cppSTLfunction equal
syntax keyword cppSTLfunction equal_range
syntax keyword cppSTLfunction erase
syntax keyword cppSTLfunction exit
syntax keyword cppSTLfunction exp
syntax keyword cppSTLfunction fabs
syntax keyword cppSTLfunction fail
syntax keyword cppSTLfunction failure
syntax keyword cppSTLfunction fclose
syntax keyword cppSTLfunction feof
syntax keyword cppSTLfunction ferror
syntax keyword cppSTLfunction fflush
syntax keyword cppSTLfunction fgetc
syntax keyword cppSTLfunction fgetpos
syntax keyword cppSTLfunction fgets
syntax keyword cppSTLfunction fill
syntax keyword cppSTLfunction fill_n
syntax keyword cppSTLfunction find
syntax keyword cppSTLfunction find_end
syntax keyword cppSTLfunction find_first_not_of
syntax keyword cppSTLfunction find_first_of
syntax keyword cppSTLfunction find_if
syntax keyword cppSTLfunction find_last_not_of
syntax keyword cppSTLfunction find_last_of
syntax keyword cppSTLfunction first
syntax keyword cppSTLfunction flags
syntax keyword cppSTLfunction flip
syntax keyword cppSTLfunction floor
syntax keyword cppSTLfunction flush
syntax keyword cppSTLfunction fmod
syntax keyword cppSTLfunction fopen
syntax keyword cppSTLfunction for_each
syntax keyword cppSTLfunction fprintf
syntax keyword cppSTLfunction fputc
syntax keyword cppSTLfunction fputs
syntax keyword cppSTLfunction fread
syntax keyword cppSTLfunction free
syntax keyword cppSTLfunction freopen
syntax keyword cppSTLfunction frexp
syntax keyword cppSTLfunction front
syntax keyword cppSTLfunction fscanf
syntax keyword cppSTLfunction fseek
syntax keyword cppSTLfunction fsetpos
syntax keyword cppSTLfunction ftell
syntax keyword cppSTLfunction fwide
syntax keyword cppSTLfunction fwprintf
syntax keyword cppSTLfunction fwrite
syntax keyword cppSTLfunction fwscanf
syntax keyword cppSTLfunction gcount
syntax keyword cppSTLfunction generate
syntax keyword cppSTLfunction generate_n
syntax keyword cppSTLfunction get
syntax keyword cppSTLfunction get_allocator
syntax keyword cppSTLfunction getc
syntax keyword cppSTLfunction getchar
syntax keyword cppSTLfunction getenv
syntax keyword cppSTLfunction getline
syntax keyword cppSTLfunction gets
syntax keyword cppSTLfunction get_temporary_buffer
syntax keyword cppSTLfunction gmtime
syntax keyword cppSTLfunction good
syntax keyword cppSTLfunction ignore
syntax keyword cppSTLfunction imag
syntax keyword cppSTLfunction in
syntax keyword cppSTLfunction includes
syntax keyword cppSTLfunction infinity
syntax keyword cppSTLfunction inner_product
syntax keyword cppSTLfunction inplace_merge
syntax keyword cppSTLfunction insert
syntax keyword cppSTLfunction inserter
syntax keyword cppSTLfunction ios
syntax keyword cppSTLfunction ios_base
syntax keyword cppSTLfunction iostate
syntax keyword cppSTLfunction iota
syntax keyword cppSTLfunction isalnum
syntax keyword cppSTLfunction isalpha
syntax keyword cppSTLfunction iscntrl
syntax keyword cppSTLfunction isdigit
syntax keyword cppSTLfunction isgraph
syntax keyword cppSTLfunction is_heap
syntax keyword cppSTLfunction islower
syntax keyword cppSTLfunction is_open
syntax keyword cppSTLfunction isprint
syntax keyword cppSTLfunction ispunct
syntax keyword cppSTLfunction isspace
syntax keyword cppSTLfunction isupper
syntax keyword cppSTLfunction isxdigit
syntax keyword cppSTLfunction iterator_category
syntax keyword cppSTLfunction iter_swap
syntax keyword cppSTLfunction jmp_buf
syntax keyword cppSTLfunction key_comp
syntax keyword cppSTLfunction labs
syntax keyword cppSTLfunction ldexp
syntax keyword cppSTLfunction ldiv
syntax keyword cppSTLfunction length
syntax keyword cppSTLfunction lexicographical_compare
syntax keyword cppSTLfunction lexicographical_compare_3way
syntax keyword cppSTLfunction llabs
syntax keyword cppSTLfunction lldiv
syntax keyword cppSTLfunction localtime
syntax keyword cppSTLfunction log
syntax keyword cppSTLfunction log10
syntax keyword cppSTLfunction longjmp
syntax keyword cppSTLfunction lower_bound
syntax keyword cppSTLfunction make_heap
syntax keyword cppSTLfunction make_pair
syntax keyword cppSTLfunction malloc
syntax keyword cppSTLfunction max
syntax keyword cppSTLfunction max_element
syntax keyword cppSTLfunction max_size
syntax keyword cppSTLfunction memchr
syntax keyword cppSTLfunction memcpy
syntax keyword cppSTLfunction mem_fun
syntax keyword cppSTLfunction mem_fun_ref
syntax keyword cppSTLfunction memmove
syntax keyword cppSTLfunction memset
syntax keyword cppSTLfunction merge
syntax keyword cppSTLfunction min
syntax keyword cppSTLfunction min_element
syntax keyword cppSTLfunction mismatch
syntax keyword cppSTLfunction mktime
syntax keyword cppSTLfunction modf
syntax keyword cppSTLfunction next_permutation
syntax keyword cppSTLfunction none
syntax keyword cppSTLfunction norm
syntax keyword cppSTLfunction not1
syntax keyword cppSTLfunction not2
syntax keyword cppSTLfunction nth_element
syntax keyword cppSTLfunction numeric_limits
syntax keyword cppSTLfunction open
syntax keyword cppSTLfunction partial_sort
syntax keyword cppSTLfunction partial_sort_copy
syntax keyword cppSTLfunction partial_sum
syntax keyword cppSTLfunction partition
syntax keyword cppSTLfunction peek
syntax keyword cppSTLfunction perror
syntax keyword cppSTLfunction polar
syntax keyword cppSTLfunction pop
syntax keyword cppSTLfunction pop_back
syntax keyword cppSTLfunction pop_front
syntax keyword cppSTLfunction pop_heap
syntax keyword cppSTLfunction pow
syntax keyword cppSTLfunction power
syntax keyword cppSTLfunction precision
syntax keyword cppSTLfunction prev_permutation
syntax keyword cppSTLfunction printf
syntax keyword cppSTLfunction ptr_fun
syntax keyword cppSTLfunction push
syntax keyword cppSTLfunction push_back
syntax keyword cppSTLfunction push_front
syntax keyword cppSTLfunction push_heap
syntax keyword cppSTLfunction put
syntax keyword cppSTLfunction putback
syntax keyword cppSTLfunction putc
syntax keyword cppSTLfunction putchar
syntax keyword cppSTLfunction puts
syntax keyword cppSTLfunction qsort
syntax keyword cppSTLfunction quiet_NaN
syntax keyword cppSTLfunction raise
syntax keyword cppSTLfunction rand
syntax keyword cppSTLfunction random_sample
syntax keyword cppSTLfunction random_sample_n
syntax keyword cppSTLfunction random_shuffle
syntax keyword cppSTLfunction rbegin
syntax keyword cppSTLfunction rdbuf
syntax keyword cppSTLfunction rdstate
syntax keyword cppSTLfunction read
syntax keyword cppSTLfunction real
syntax keyword cppSTLfunction realloc
syntax keyword cppSTLfunction remove
syntax keyword cppSTLfunction remove_copy
syntax keyword cppSTLfunction remove_copy_if
syntax keyword cppSTLfunction remove_if
syntax keyword cppSTLfunction rename
syntax keyword cppSTLfunction rend
syntax keyword cppSTLfunction replace
syntax keyword cppSTLfunction replace_copy
syntax keyword cppSTLfunction replace_copy_if
syntax keyword cppSTLfunction replace_if
syntax keyword cppSTLfunction reserve
syntax keyword cppSTLfunction reset
syntax keyword cppSTLfunction resize
syntax keyword cppSTLfunction return_temporary_buffer
syntax keyword cppSTLfunction reverse
syntax keyword cppSTLfunction reverse_copy
syntax keyword cppSTLfunction rewind
syntax keyword cppSTLfunction rfind
syntax keyword cppSTLfunction rotate
syntax keyword cppSTLfunction rotate_copy
syntax keyword cppSTLfunction round_error
syntax keyword cppSTLfunction scanf
syntax keyword cppSTLfunction search
syntax keyword cppSTLfunction search_n
syntax keyword cppSTLfunction second
syntax keyword cppSTLfunction seekg
syntax keyword cppSTLfunction seekp
syntax keyword cppSTLfunction setbuf
syntax keyword cppSTLfunction set_difference
syntax keyword cppSTLfunction setf
syntax keyword cppSTLfunction set_intersection
syntax keyword cppSTLfunction setjmp
syntax keyword cppSTLfunction setlocale
syntax keyword cppSTLfunction set_new_handler
syntax keyword cppSTLfunction set_symmetric_difference
syntax keyword cppSTLfunction set_union
syntax keyword cppSTLfunction setvbuf
syntax keyword cppSTLfunction signal
syntax keyword cppSTLfunction signaling_NaN
syntax keyword cppSTLfunction sin
syntax keyword cppSTLfunction sinh
syntax keyword cppSTLfunction size
syntax keyword cppSTLfunction sort
syntax keyword cppSTLfunction sort_heap
syntax keyword cppSTLfunction splice
syntax keyword cppSTLfunction sprintf
syntax keyword cppSTLfunction sqrt
syntax keyword cppSTLfunction srand
syntax keyword cppSTLfunction sscanf
syntax keyword cppSTLfunction stable_partition
syntax keyword cppSTLfunction stable_sort
syntax keyword cppSTLfunction str
syntax keyword cppSTLfunction strcat
syntax keyword cppSTLfunction strchr
syntax keyword cppSTLfunction strcmp
syntax keyword cppSTLfunction strcoll
syntax keyword cppSTLfunction strcpy
syntax keyword cppSTLfunction strcspn
syntax keyword cppSTLfunction strerror
syntax keyword cppSTLfunction strftime
syntax keyword cppSTLfunction string
syntax keyword cppSTLfunction strlen
syntax keyword cppSTLfunction strncat
syntax keyword cppSTLfunction strncmp
syntax keyword cppSTLfunction strncpy
syntax keyword cppSTLfunction strpbrk
syntax keyword cppSTLfunction strrchr
syntax keyword cppSTLfunction strspn
syntax keyword cppSTLfunction strstr
syntax keyword cppSTLfunction strtod
syntax keyword cppSTLfunction strtok
syntax keyword cppSTLfunction strtol
syntax keyword cppSTLfunction strtoul
syntax keyword cppSTLfunction strxfrm
syntax keyword cppSTLfunction substr
syntax keyword cppSTLfunction swap
syntax keyword cppSTLfunction swap_ranges
syntax keyword cppSTLfunction swprintf
syntax keyword cppSTLfunction swscanf
syntax keyword cppSTLfunction sync_with_stdio
syntax keyword cppSTLfunction system
syntax keyword cppSTLfunction tan
syntax keyword cppSTLfunction tanh
syntax keyword cppSTLfunction tellg
syntax keyword cppSTLfunction tellp
syntax keyword cppSTLfunction test
syntax keyword cppSTLfunction time
syntax keyword cppSTLfunction time_t
syntax keyword cppSTLfunction tmpfile
syntax keyword cppSTLfunction tmpnam
syntax keyword cppSTLfunction tolower
syntax keyword cppSTLfunction top
syntax keyword cppSTLfunction to_string
syntax keyword cppSTLfunction to_ulong
syntax keyword cppSTLfunction toupper
syntax keyword cppSTLfunction to_wstring
syntax keyword cppSTLfunction transform
syntax keyword cppSTLfunction unary_compose
syntax keyword cppSTLfunction unget
syntax keyword cppSTLfunction ungetc
syntax keyword cppSTLfunction uninitialized_copy
syntax keyword cppSTLfunction uninitialized_copy_n
syntax keyword cppSTLfunction uninitialized_fill
syntax keyword cppSTLfunction uninitialized_fill_n
syntax keyword cppSTLfunction unique
syntax keyword cppSTLfunction unique_copy
syntax keyword cppSTLfunction unsetf
syntax keyword cppSTLfunction upper_bound
syntax keyword cppSTLfunction va_arg
syntax keyword cppSTLfunction va_arg
syntax keyword cppSTLfunction va_copy
syntax keyword cppSTLfunction va_end
syntax keyword cppSTLfunction value_comp
syntax keyword cppSTLfunction va_start
syntax keyword cppSTLfunction vfprintf
syntax keyword cppSTLfunction vfwprintf
syntax keyword cppSTLfunction vprintf
syntax keyword cppSTLfunction vsprintf
syntax keyword cppSTLfunction vswprintf
syntax keyword cppSTLfunction vwprintf
syntax keyword cppSTLfunction width
syntax keyword cppSTLfunction wprintf
syntax keyword cppSTLfunction write
syntax keyword cppSTLfunction wscanf
syntax keyword cppSTLios boolalpha
syntax keyword cppSTLios dec
syntax keyword cppSTLios defaultfloat
syntax keyword cppSTLios endl
syntax keyword cppSTLios ends
syntax keyword cppSTLios fixed
syntax keyword cppSTLios flush
syntax keyword cppSTLios get_money
syntax keyword cppSTLios get_time
syntax keyword cppSTLios hex
syntax keyword cppSTLios hexfloat
syntax keyword cppSTLios internal
syntax keyword cppSTLios noboolalpha
syntax keyword cppSTLios noshowbase
syntax keyword cppSTLios noshowpoint
syntax keyword cppSTLios noshowpos
syntax keyword cppSTLios noskipws
syntax keyword cppSTLios nounitbuf
syntax keyword cppSTLios nouppercase
syntax keyword cppSTLios oct
syntax keyword cppSTLios put_money
syntax keyword cppSTLios put_time
syntax keyword cppSTLios resetiosflags
syntax keyword cppSTLios scientific
syntax keyword cppSTLios setbase
syntax keyword cppSTLios setfill
syntax keyword cppSTLios setiosflags
syntax keyword cppSTLios setprecision
syntax keyword cppSTLios setw
syntax keyword cppSTLios showbase
syntax keyword cppSTLios showpoint
syntax keyword cppSTLios showpos
syntax keyword cppSTLios skipws
syntax keyword cppSTLios unitbuf
syntax keyword cppSTLios uppercase
"syntax keyword cppSTLios ws
syntax keyword cppSTLiterator back_insert_iterator
syntax keyword cppSTLiterator bidirectional_iterator
syntax keyword cppSTLiterator const_iterator
syntax keyword cppSTLiterator const_reverse_iterator
syntax keyword cppSTLiterator forward_iterator
syntax keyword cppSTLiterator front_insert_iterator
syntax keyword cppSTLiterator input_iterator
syntax keyword cppSTLiterator insert_iterator
syntax keyword cppSTLiterator istreambuf_iterator
syntax keyword cppSTLiterator istream_iterator
syntax keyword cppSTLiterator iterator
syntax keyword cppSTLiterator ostream_iterator
syntax keyword cppSTLiterator output_iterator
syntax keyword cppSTLiterator random_access_iterator
syntax keyword cppSTLiterator raw_storage_iterator
syntax keyword cppSTLiterator reverse_bidirectional_iterator
syntax keyword cppSTLiterator reverse_iterator
syntax keyword cppSTLiterator_tag bidirectional_iterator_tag
syntax keyword cppSTLiterator_tag forward_iterator_tag
syntax keyword cppSTLiterator_tag input_iterator_tag
syntax keyword cppSTLiterator_tag output_iterator_tag
syntax keyword cppSTLiterator_tag random_access_iterator_tag
syntax keyword cppSTLnamespace rel_ops
syntax keyword cppSTLnamespace std
syntax keyword cppSTLtype allocator
syntax keyword cppSTLtype auto_ptr
syntax keyword cppSTLtype basic_fstream
syntax keyword cppSTLtype basic_ifstream
syntax keyword cppSTLtype basic_istringstream
syntax keyword cppSTLtype basic_ofstream
syntax keyword cppSTLtype basic_ostringstream
syntax keyword cppSTLtype basic_string
syntax keyword cppSTLtype basic_stringstream
syntax keyword cppSTLtype binary_compose
syntax keyword cppSTLtype binder1st
syntax keyword cppSTLtype binder2nd
syntax keyword cppSTLtype bitset
syntax keyword cppSTLtype char_traits
syntax keyword cppSTLtype char_type
syntax keyword cppSTLtype const_mem_fun1_t
syntax keyword cppSTLtype const_mem_fun_ref1_t
syntax keyword cppSTLtype const_mem_fun_ref_t
syntax keyword cppSTLtype const_mem_fun_t
syntax keyword cppSTLtype const_pointer
syntax keyword cppSTLtype const_reference
syntax keyword cppSTLtype deque
syntax keyword cppSTLtype difference_type
syntax keyword cppSTLtype div_t
syntax keyword cppSTLtype double_t
syntax keyword cppSTLtype filebuf
syntax keyword cppSTLtype first_type
syntax keyword cppSTLtype float_denorm_style
syntax keyword cppSTLtype float_round_style
syntax keyword cppSTLtype float_t
syntax keyword cppSTLtype fstream
syntax keyword cppSTLtype gslice_array
syntax keyword cppSTLtype ifstream
syntax keyword cppSTLtype imaxdiv_t
syntax keyword cppSTLtype indirect_array
syntax keyword cppSTLtype int_type
syntax keyword cppSTLtype istringstream
syntax keyword cppSTLtype iterator_traits
syntax keyword cppSTLtype key_compare
syntax keyword cppSTLtype key_type
syntax keyword cppSTLtype ldiv_t
syntax keyword cppSTLtype list
syntax keyword cppSTLtype lldiv_t
syntax keyword cppSTLtype map
syntax keyword cppSTLtype mapped_type
syntax keyword cppSTLtype mask_array
syntax keyword cppSTLtype mem_fun1_t
syntax keyword cppSTLtype mem_fun_ref1_t
syntax keyword cppSTLtype mem_fun_ref_t
syntax keyword cppSTLtype mem_fun_t
syntax keyword cppSTLtype multimap
syntax keyword cppSTLtype multiset
syntax keyword cppSTLtype nothrow_t
syntax keyword cppSTLtype off_type
syntax keyword cppSTLtype ofstream
syntax keyword cppSTLtype ostream
syntax keyword cppSTLtype ostringstream
syntax keyword cppSTLtype pair
syntax keyword cppSTLtype pointer
syntax keyword cppSTLtype pointer_to_binary_function
syntax keyword cppSTLtype pointer_to_unary_function
syntax keyword cppSTLtype pos_type
syntax keyword cppSTLtype priority_queue
syntax keyword cppSTLtype queue
syntax keyword cppSTLtype reference
syntax keyword cppSTLtype second_type
syntax keyword cppSTLtype sequence_buffer
syntax keyword cppSTLtype set
syntax keyword cppSTLtype sig_atomic_t
syntax keyword cppSTLtype size_type
syntax keyword cppSTLtype slice_array
syntax keyword cppSTLtype stack
syntax keyword cppSTLtype stream
syntax keyword cppSTLtype string
syntax keyword cppSTLtype stringbuf
syntax keyword cppSTLtype stringstream
syntax keyword cppSTLtype temporary_buffer
syntax keyword cppSTLtype test_type
syntax keyword cppSTLtype tm
syntax keyword cppSTLtype traits_type
syntax keyword cppSTLtype type_info
syntax keyword cppSTLtype u16string
syntax keyword cppSTLtype u32string
syntax keyword cppSTLtype unary_compose
syntax keyword cppSTLtype unary_negate
syntax keyword cppSTLtype valarray
syntax keyword cppSTLtype value_compare
syntax keyword cppSTLtype value_type
syntax keyword cppSTLtype vector
syntax keyword cppSTLtype wfstream
syntax keyword cppSTLtype wifstream
syntax keyword cppSTLtype wistringstream
syntax keyword cppSTLtype wofstream
syntax keyword cppSTLtype wostringstream
syntax keyword cppSTLtype wstring
syntax keyword cppSTLtype wstringbuf
syntax keyword cppSTLtype wstringstream

if !exists("cpp_no_cpp11")
    syntax keyword cppSTLtype nullptr_t max_align_t
    syntax keyword cppSTLtype type_index

    " type_traits
    syntax keyword cppSTLtype is_void
    syntax keyword cppSTLtype is_integral
    syntax keyword cppSTLtype is_floating_point
    syntax keyword cppSTLtype is_array
    syntax keyword cppSTLtype is_enum
    syntax keyword cppSTLtype is_union
    syntax keyword cppSTLtype is_class
    syntax keyword cppSTLtype is_function
    syntax keyword cppSTLtype is_pointer
    syntax keyword cppSTLtype is_lvalue_reference
    syntax keyword cppSTLtype is_rvalue_reference
    syntax keyword cppSTLtype is_member_object_pointer
    syntax keyword cppSTLtype is_member_function_pointer
    syntax keyword cppSTLtype is_fundamental
    syntax keyword cppSTLtype is_arithmetic
    syntax keyword cppSTLtype is_scalar
    syntax keyword cppSTLtype is_object
    syntax keyword cppSTLtype is_compound
    syntax keyword cppSTLtype is_reference
    syntax keyword cppSTLtype is_member_pointer
    syntax keyword cppSTLtype is_const
    syntax keyword cppSTLtype is_volatile
    syntax keyword cppSTLtype is_trivial
    syntax keyword cppSTLtype is_trivially_copyable
    syntax keyword cppSTLtype is_standard_layout
    syntax keyword cppSTLtype is_pod
    syntax keyword cppSTLtype is_literal_type
    syntax keyword cppSTLtype is_empty
    syntax keyword cppSTLtype is_polymorphic
    syntax keyword cppSTLtype is_abstract
    syntax keyword cppSTLtype is_signed
    syntax keyword cppSTLtype is_unsigned
    syntax keyword cppSTLtype is_constructible
    syntax keyword cppSTLtype is_trivially_constructible
    syntax keyword cppSTLtype is_nothrow_constructible
    syntax keyword cppSTLtype is_default_constructible
    syntax keyword cppSTLtype is_trivially_default_constructible
    syntax keyword cppSTLtype is_nothrow_default_constructible
    syntax keyword cppSTLtype is_copy_constructible
    syntax keyword cppSTLtype is_trivially_copy_constructible
    syntax keyword cppSTLtype is_nothrow_copy_constructible
    syntax keyword cppSTLtype is_move_constructible
    syntax keyword cppSTLtype is_trivially_move_constructible
    syntax keyword cppSTLtype is_nothrow_move_constructible
    syntax keyword cppSTLtype is_assignable
    syntax keyword cppSTLtype is_trivially_assignable
    syntax keyword cppSTLtype is_nothrow_assignable
    syntax keyword cppSTLtype is_copy_assignable
    syntax keyword cppSTLtype is_trivially_copy_assignable
    syntax keyword cppSTLtype is_nothrow_copy_assignable
    syntax keyword cppSTLtype is_move_assignable
    syntax keyword cppSTLtype is_trivially_move_assignable
    syntax keyword cppSTLtype is_nothrow_move_assignable
    syntax keyword cppSTLtype is_destructible
    syntax keyword cppSTLtype is_trivially_destructible
    syntax keyword cppSTLtype alignment_of
    syntax keyword cppSTLtype rank
    syntax keyword cppSTLtype extent
    syntax keyword cppSTLtype is_same
    syntax keyword cppSTLtype is_base_of
    syntax keyword cppSTLtype is_convertible
    syntax keyword cppSTLtype remove_cv
    syntax keyword cppSTLtype remove_const
    syntax keyword cppSTLtype remove_volatile
    syntax keyword cppSTLtype add_cv
    syntax keyword cppSTLtype add_const
    syntax keyword cppSTLtype add_volatile
    syntax keyword cppSTLtype remove_reference
    syntax keyword cppSTLtype add_lvalue_reference
    syntax keyword cppSTLtype add_rvalue_reference
    syntax keyword cppSTLtype remove_pointer
    syntax keyword cppSTLtype add_pointer
    syntax keyword cppSTLtype make_signed
    syntax keyword cppSTLtype make_unsigned
    syntax keyword cppSTLtype remove_extent
    syntax keyword cppSTLtype remove_all_extents
    syntax keyword cppSTLtype aligned_storage
    syntax keyword cppSTLtype aligned_union
    syntax keyword cppSTLtype decay
    syntax keyword cppSTLtype enable_if
    syntax keyword cppSTLtype conditional
    syntax keyword cppSTLtype common_type
    syntax keyword cppSTLtype underlying_type
    syntax keyword cppSTLtype result_of
    syntax keyword cppSTLtype integral_constant
    syntax keyword cppSTLtype true_type
    syntax keyword cppSTLtype false_type

    " memory
    syntax keyword cppSTLtype unique_ptr
    syntax keyword cppSTLtype shared_ptr
    syntax keyword cppSTLtype weak_ptr
    syntax keyword cppSTLtype owner_less
    syntax keyword cppSTLtype enable_shared_from_this
    syntax keyword cppSTLexception bad_weak_ptr
    syntax keyword cppSTLtype default_delete
    syntax keyword cppSTLtype allocator_traits
    syntax keyword cppSTLtype allocator_type
    syntax keyword cppSTLtype allocator_arg_t
    syntax keyword cppSTLconstant allocator_arg
    syntax keyword cppSTLtype uses_allocator
    syntax keyword cppSTLtype scoped_allocator_adaptor
    syntax keyword cppSTLfunction declare_reachable
    syntax keyword cppSTLfunction undeclare_reachable
    syntax keyword cppSTLfunction declare_no_pointers
    syntax keyword cppSTLfunction undeclare_no_pointers
    syntax keyword cppSTLfunction get_pointer_safety
    syntax keyword cppSTLtype pointer_safety
    syntax keyword cppSTLtype pointer_traits
    syntax keyword cppSTLfunction addressof
    syntax keyword cppSTLfunction align

    " function object
    syntax keyword cppSTLfunction bind
    syntax keyword cppSTLtype is_bind_expression
    syntax keyword cppSTLtype is_placeholder
    syntax keyword cppSTLconstant _1 _2 _3 _4 _5 _6 _7 _8 _9
    syntax keyword cppSTLfunction mem_fn
    syntax keyword cppSTLfunctional function
    syntax keyword cppSTLexception bad_function_call
    syntax keyword cppSTLtype reference_wrapper
    syntax keyword cppSTLfunction ref cref

    " bitset
    syntax keyword cppSTLfunction all
    syntax keyword cppSTLfunction to_ullong

    " iterator
    syntax keyword cppSTLiterator move_iterator
    syntax keyword cppSTLfunction make_move_iterator
    syntax keyword cppSTLfunction next prev

    " program support utilities
    syntax keyword cppSTLfunction quick_exit
    syntax keyword cppSTLfunction _Exit
    syntax keyword cppSTLfunction at_quick_exit

    " date and time
    syntax keyword cppSTLnamespace chrono
    syntax keyword cppSTLtype duration
    syntax keyword cppSTLtype system_clock
    syntax keyword cppSTLtype steady_clock
    syntax keyword cppSTLtype high_resolution_clock
    syntax keyword cppSTLtype time_point

    " tuple
    syntax keyword cppSTLtype tuple
    syntax keyword cppSTLfunction make_tuple
    syntax keyword cppSTLfunction tie
    syntax keyword cppSTLfunction forward_as_tuple
    syntax keyword cppSTLfunction tuple_cat
    syntax keyword cppSTLtype tuple_size tuple_element

    " Container
    syntax keyword cppSTLtype array
    syntax keyword cppSTLtype forward_list
    syntax keyword cppSTLtype unordered_map
    syntax keyword cppSTLtype unordered_set
    syntax keyword cppSTLtype unordered_multimap
    syntax keyword cppSTLtype unordered_multiset
    syntax keyword cppSTLtype tuple
    syntax keyword cppSTLfunction cbegin
    syntax keyword cppSTLfunction cend
    syntax keyword cppSTLfunction crbegin
    syntax keyword cppSTLfunction crend
    syntax keyword cppSTLfunction shrink_to_fit
    syntax keyword cppSTLfunction emplace
    syntax keyword cppSTLfunction emplace_back
    syntax keyword cppSTLfunction emplace_front
    syntax keyword cppSTLfunction emplace_hint

    "forward_list
    syntax keyword cppSTLfunction before_begin
    syntax keyword cppSTLfunction cbefore_begin
    syntax keyword cppSTLfunction insert_after
    syntax keyword cppSTLfunction emplace_after
    syntax keyword cppSTLfunction erase_after
    syntax keyword cppSTLfunction splice_after

    " unordered
    syntax keyword cppSTLtype hash
    syntax keyword cppSTLtype hasher
    syntax keyword cppSTLtype key_equal
    syntax keyword cppSTLiterator local_iterator
    syntax keyword cppSTLiterator const_local_iterator
    syntax keyword cppSTLfunction bucket_count
    syntax keyword cppSTLfunction max_bucket_count
    syntax keyword cppSTLfunction bucket_size
    syntax keyword cppSTLfunction bucket
    syntax keyword cppSTLfunction load_factor
    syntax keyword cppSTLfunction max_load_factor
    syntax keyword cppSTLfunction rehash
    syntax keyword cppSTLfunction reserve
    syntax keyword cppSTLfunction hash_function
    syntax keyword cppSTLfunction key_eq

    " algorithm
    syntax keyword cppSTLfunction all_of any_of none_of
    syntax keyword cppSTLfunction find_if_not
    syntax keyword cppSTLfunction copy_if
    syntax keyword cppSTLfunction copy_n
    syntax keyword cppSTLfunction move
    syntax keyword cppSTLfunction move_backward
    syntax keyword cppSTLfunction shuffle
    syntax keyword cppSTLfunction is_partitioned
    syntax keyword cppSTLfunction partition_copy
    syntax keyword cppSTLfunction partition_point
    syntax keyword cppSTLfunction is_sorted
    syntax keyword cppSTLfunction is_sorted_until
    syntax keyword cppSTLfunction is_heap_until
    syntax keyword cppSTLfunction minmax
    syntax keyword cppSTLfunction minmax_element
    syntax keyword cppSTLfunction is_permutation
    syntax keyword cppSTLfunction itoa

    " numerics
    syntax keyword cppSTLfunction imaxabs
    syntax keyword cppSTLfunction imaxdiv
    syntax keyword cppSTLfunction remainder
    syntax keyword cppSTLfunction remquo
    syntax keyword cppSTLfunction fma
    syntax keyword cppSTLfunction fmax
    syntax keyword cppSTLfunction fmin
    syntax keyword cppSTLfunction fdim
    syntax keyword cppSTLfunction nan
    syntax keyword cppSTLfunction nanf
    syntax keyword cppSTLfunction nanl
    syntax keyword cppSTLfunction exp2
    syntax keyword cppSTLfunction expm1
    syntax keyword cppSTLfunction log1p
    syntax keyword cppSTLfunction log2
    syntax keyword cppSTLfunction cbrt
    syntax keyword cppSTLfunction hypot
    syntax keyword cppSTLfunction asinh
    syntax keyword cppSTLfunction acosh
    syntax keyword cppSTLfunction atanh
    syntax keyword cppSTLfunction erf
    syntax keyword cppSTLfunction erfc
    syntax keyword cppSTLfunction lgamma
    syntax keyword cppSTLfunction tgamma
    syntax keyword cppSTLfunction trunc
    syntax keyword cppSTLfunction round
    syntax keyword cppSTLfunction lround
    syntax keyword cppSTLfunction llround
    syntax keyword cppSTLfunction nearbyint
    syntax keyword cppSTLfunction rint
    syntax keyword cppSTLfunction lrint
    syntax keyword cppSTLfunction llrint
    syntax keyword cppSTLfunction scalbn
    syntax keyword cppSTLfunction scalbln
    syntax keyword cppSTLfunction ilogb
    syntax keyword cppSTLfunction logb
    syntax keyword cppSTLfunction nextafter
    syntax keyword cppSTLfunction nexttoward
    syntax keyword cppSTLfunction copysign
    syntax keyword cppSTLfunction fpclassify
    syntax keyword cppSTLfunction isfinite
    syntax keyword cppSTLfunction isinf
    syntax keyword cppSTLfunction isnan
    syntax keyword cppSTLfunction isnormal
    syntax keyword cppSTLfunction signbit
    syntax keyword cppSTLconstant HUGE_VALF
    syntax keyword cppSTLconstant HUGE_VALL
    syntax keyword cppSTLconstant INFINITY
    syntax keyword cppSTLconstant NAN
    syntax keyword cppSTLconstant math_errhandling
    syntax keyword cppSTLconstant MATH_ERRNO
    syntax keyword cppSTLconstant MATH_ERREXCEPT
    syntax keyword cppSTLconstant FP_NORMAL
    syntax keyword cppSTLconstant FP_SUBNORMAL
    syntax keyword cppSTLconstant FP_ZERO
    syntax keyword cppSTLconstant FP_INFINITY
    syntax keyword cppSTLconstant FP_NAN
    syntax keyword cppSTLconstant FLT_EVAL_METHOD

    " complex
    syntax keyword cppSTLfunction proj

    " random
    syntax keyword cppSTLtype linear_congruential_engine
    syntax keyword cppSTLtype mersenne_twister_engine
    syntax keyword cppSTLtype subtract_with_carry_engine
    syntax keyword cppSTLtype discard_block_engine
    syntax keyword cppSTLtype independent_bits_engine
    syntax keyword cppSTLtype shuffle_order_engine
    syntax keyword cppSTLtype random_device
    syntax keyword cppSTLtype default_random_engine
    syntax keyword cppSTLtype minstd_rand0
    syntax keyword cppSTLtype minstd_rand
    syntax keyword cppSTLtype mt19937
    syntax keyword cppSTLtype mt19937_64
    syntax keyword cppSTLtype ranlux24_base
    syntax keyword cppSTLtype ranlux48_base
    syntax keyword cppSTLtype ranlux24
    syntax keyword cppSTLtype ranlux48
    syntax keyword cppSTLtype knuth_b
    syntax keyword cppSTLfunction generate_canonical
    syntax keyword cppSTLtype uniform_int_distribution
    syntax keyword cppSTLtype uniform_real_distribution
    syntax keyword cppSTLtype bernoulli_distribution
    syntax keyword cppSTLtype binomial_distribution
    syntax keyword cppSTLtype negative_binomial_distribution
    syntax keyword cppSTLtype geometric_distribution
    syntax keyword cppSTLtype poisson_distribution
    syntax keyword cppSTLtype exponential_distribution
    syntax keyword cppSTLtype gamma_distribution
    syntax keyword cppSTLtype weibull_distribution
    syntax keyword cppSTLtype extreme_value_distribution
    syntax keyword cppSTLtype normal_distribution
    syntax keyword cppSTLtype lognormal_distribution
    syntax keyword cppSTLtype chi_squared_distribution
    syntax keyword cppSTLtype cauchy_distribution
    syntax keyword cppSTLtype fisher_f_distribution
    syntax keyword cppSTLtype student_t_distribution
    syntax keyword cppSTLtype discrete_distribution
    syntax keyword cppSTLtype piecewise_constant_distribution
    syntax keyword cppSTLtype piecewise_linear_distribution
    syntax keyword cppSTLtype seed_seq

    " io
    syntax keyword cppSTLfunction iostream_category
    syntax keyword cppSTLenum io_errc
    syntax keyword cppSTLfunction vscanf vfscanf vsscanf
    syntax keyword cppSTLfunction snprintf vsnprintf
    syntax keyword cppSTLfunction vwscanf vfwscanf vswscanf

    " locale
    syntax keyword cppSTLfunction isblank
    syntax keyword cppSTLtype wstring_convert
    syntax keyword cppSTLtype wbuffer_convert
    syntax keyword cppSTLtype codecvt_utf8
    syntax keyword cppSTLtype codecvt_utf16
    syntax keyword cppSTLtype codecvt_utf8_utf16
    syntax keyword cppSTLtype codecvt_mode

    " regex
    syntax keyword cppSTLtype basic_regex
    syntax keyword cppSTLtype sub_match
    syntax keyword cppSTLtype match_results
    syntax keyword cppSTLtype regex_traits
    syntax keyword cppSTLtype regex_match regex_search regex_replace
    syntax keyword cppSTLiterator regex_iterator
    syntax keyword cppSTLiterator regex_token_iterator
    syntax keyword cppSTLexception regex_error
    syntax keyword cppSTLtype syntax_option_type match_flag_type error_type

    " atomic
    syntax keyword cppSTLtype atomic
    syntax keyword cppSTLfunction atomic_is_lock_free
    syntax keyword cppSTLfunction atomic_store
    syntax keyword cppSTLfunction atomic_store_explicit
    syntax keyword cppSTLfunction atomic_load
    syntax keyword cppSTLfunction atomic_load_explicit
    syntax keyword cppSTLfunction atomic_exchange
    syntax keyword cppSTLfunction atomic_exchange_explicit
    syntax keyword cppSTLfunction atomic_compare_exchange_weak
    syntax keyword cppSTLfunction atomic_compare_exchange_weak_explicit
    syntax keyword cppSTLfunction atomic_compare_exchange_strong
    syntax keyword cppSTLfunction atomic_compare_exchange_strong_explicit
    syntax keyword cppSTLfunction atomic_fetch_add
    syntax keyword cppSTLfunction atomic_fetch_add_explicit
    syntax keyword cppSTLfunction atomic_fetch_sub
    syntax keyword cppSTLfunction atomic_fetch_sub_explicit
    syntax keyword cppSTLfunction atomic_fetch_and
    syntax keyword cppSTLfunction atomic_fetch_and_explicit
    syntax keyword cppSTLfunction atomic_fetch_or
    syntax keyword cppSTLfunction atomic_fetch_or_explicit
    syntax keyword cppSTLfunction atomic_fetch_xor
    syntax keyword cppSTLfunction atomic_fetch_xor_explicit

    syntax keyword cppSTLtype atomic_flag
    syntax keyword cppSTLfunction atomic_flag_test_and_set
    syntax keyword cppSTLfunction atomic_flag_test_and_set_explicit
    syntax keyword cppSTLfunction atomic_flag_clear
    syntax keyword cppSTLfunction atomic_flag_clear_explicit

    syntax keyword cppSTLtype memory_order
    syntax keyword cppSTLfunction atomic_init
    syntax keyword cppSTLfunction ATOMIC_VAR_INIT
    syntax keyword cppSTLconstant ATOMIC_FLAG_INIT
    syntax keyword cppSTLconstant kill_dependency
    syntax keyword cppSTLconstant atomic_thread_fence
    syntax keyword cppSTLconstant atomic_signal_fence

    " thread
    syntax keyword cppSTLtype thread
    syntax keyword cppSTLfunction yield
    syntax keyword cppSTLfunction get_id
    syntax keyword cppSTLfunction sleep_for
    syntax keyword cppSTLfunction sleep_until

    syntax keyword cppSTLfunction joinable
    syntax keyword cppSTLfunction get_id
    syntax keyword cppSTLfunction native_handle
    syntax keyword cppSTLfunction hardware_concurrency
    syntax keyword cppSTLfunction join
    syntax keyword cppSTLfunction detach

    syntax keyword cppSTLtype mutex
    syntax keyword cppSTLtype timed_mutex
    syntax keyword cppSTLtype recursive_mutex
    syntax keyword cppSTLtype recursive_timed_mutex
    syntax keyword cppSTLtype lock_guard
    syntax keyword cppSTLtype unique_lock
    syntax keyword cppSTLtype defer_lock_t
    syntax keyword cppSTLtype try_to_lock_t
    syntax keyword cppSTLtype adopt_lock_t
    syntax keyword cppSTLconstant defer_lock try_to_lock adopt_lock
    syntax keyword cppSTLfunction try_lock lock
    syntax keyword cppSTLfunction call_once
    syntax keyword cppSTLtype once_flag
    syntax keyword cppSTLtype condition_variable
    syntax keyword cppSTLtype condition_variable_any
    syntax keyword cppSTLfunction notify_all_at_thread_exit
    syntax keyword cppSTLenum cv_status

    syntax keyword cppSTLtype promise
    syntax keyword cppSTLtype packaged_task
    syntax keyword cppSTLtype future
    syntax keyword cppSTLtype shared_future

    "syntax keyword cppSTLfunction async
    "syntax keyword cppSTLenum launch

    syntax keyword cppSTLenum future_status
    syntax keyword cppSTLenum future_errc
    syntax keyword cppSTLtype future_error
    syntax keyword cppSTLfunction future_category

    " string
    syntax keyword cppSTLfunction stoi
    syntax keyword cppSTLfunction stol
    syntax keyword cppSTLfunction stoll
    syntax keyword cppSTLfunction stoul
    syntax keyword cppSTLfunction stoull
    syntax keyword cppSTLfunction stof
    syntax keyword cppSTLfunction stod
    syntax keyword cppSTLfunction stold

    " ratio
    syntax keyword cppSTLtype ratio
    syntax keyword cppSTLtype yocto
    syntax keyword cppSTLtype zepto
    syntax keyword cppSTLtype atto
    syntax keyword cppSTLtype femto
    syntax keyword cppSTLtype pico
    syntax keyword cppSTLtype nano
    syntax keyword cppSTLtype micro
    syntax keyword cppSTLtype milli
    syntax keyword cppSTLtype centi
    syntax keyword cppSTLtype deci
    syntax keyword cppSTLtype deca
    syntax keyword cppSTLtype hecto
    syntax keyword cppSTLtype kilo
    syntax keyword cppSTLtype mega
    syntax keyword cppSTLtype giga
    syntax keyword cppSTLtype tera
    syntax keyword cppSTLtype peta
    syntax keyword cppSTLtype exa
    syntax keyword cppSTLtype zetta
    syntax keyword cppSTLtype yotta
    syntax keyword cppSTLtype ratio_add
    syntax keyword cppSTLtype ratio_subtract
    syntax keyword cppSTLtype ratio_multiply
    syntax keyword cppSTLtype ratio_divide
    syntax keyword cppSTLtype ratio_equal
    syntax keyword cppSTLtype ratio_not_equal
    syntax keyword cppSTLtype ratio_less
    syntax keyword cppSTLtype ratio_less_equal
    syntax keyword cppSTLtype ratio_greater
    syntax keyword cppSTLtype ratio_greater_equal

    "limits
    syntax keyword cppSTLfunction lowest
endif

" C++ extentions
"syn keyword cppSTL		compose1 compose2 istream mem_fun1 mem_fun1_ref size_t
"syn keyword cppSTLtype bit_vector char_producer hash_map hash_multimap hash_multiset hash_set rope

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syn keyword	cRepeat     BOOST_FOREACH

syn match cppCast		"\<\(const\|static\|dynamic\|reinterpret\)_cast\s*<"me=e-1
syn match cppCast		"\<\(const\|static\|dynamic\|reinterpret\)_cast\s*$"
syn keyword cppStatement	new delete this friend using
syn keyword cppAccess		public protected private
syn keyword cppNamespace        std boost
syn keyword cppType		inline virtual explicit export bool wchar_t
syn keyword cppExceptions	throw try catch
syn keyword cppOperator		operator typeid
syn keyword cppOperator		and bitor or xor compl bitand and_eq or_eq xor_eq not not_eq
syn keyword cppStorageClass	mutable
syn keyword cppStructure	class typename template namespace
syn keyword cppNumber		NPOS
syn keyword cppBoolean		true false

"" The minimum and maximum operators in GNU C++
syn match cppMinMax "[<>]?"

" Default highlighting
if version >= 508 || !exists("did_cpp_syntax_inits")
  if version < 508
    let did_cpp_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  "HiLink cppSTL		Identifier
  "HiLink cppSTLtype             Type
  HiLink cppSTLfunction     Function
  HiLink cppSTLfunctional   Function
  HiLink cppSTLconstant     Constant
  HiLink cppSTLnamespace    Macro
  HiLink cppSTLtype         Type
  HiLink cppSTLexception    Error
  HiLink cppSTLiterator     Type
  HiLink cppSTLiterator_tag Tag
  HiLink cppSTLenum         Type
  HiLink cppSTLios          Function

  HiLink cppMinMax              Delimiter
  HiLink cppStatement		Statement
  HiLink cppAccess		Special
  HiLink cppExceptions		Exception
  HiLink cppType		Type
  HiLink cppOperator		Operator
  HiLink cppCast		Statement
  HiLink cppStorageClass	StorageClass
  HiLink cppStructure		Structure
  HiLink cppNumber		Number
  HiLink cppBoolean		Boolean
  HiLink cppNamespace           Macro
  delcommand HiLink
endif

let b:current_syntax = "cpp"

" vim: ts=8

