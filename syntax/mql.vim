if exists("b:current_syntax")
  finish
endif

syntax keyword mqlStatement return break continue
highlight default link mqlStatement Statement

syntax keyword mqlRepeat for while until
highlight default link repeat Repeat

syntax keyword mqlConditional if else unless switch when then
highlight default link mqlConditional Conditional

syntax keyword mqlException try catch finally
highlight default link mqlException Exception

syntax keyword mqlOperator instanceof typeof delete
highlight default link mqlOperator Operator

syntax keyword mqlKeyword new in of by where and or not is isnt
\                            class extends super
highlight default link mqlKeyword Keyword

syntax keyword mqlBoolean true TRUE false FALSE EMPTY_VALUE EMPTY
highlight default link mqlBoolean Boolean

syntax keyword mqlGlobal null NULL
highlight default link mqlGlobal Type

syntax keyword mqlVar this prototype arguments
syntax match mqlVar /@\%(\I\i*\)\?/
highlight default link mqlVar Type

" Matches class-like names that start with a capital letter, like Array or
" Object
syntax match mqlObject /\<\u\w*\>/
highlight default link mqlObject Structure

" Matches constant-like names in SCREAMING_CAPS
syntax match mqlConstant /\<\u[A-Z0-9_]\+\>/
highlight default link mqlConstant Constant

syntax match mqlPrototype /::/
highlight default link mqlPrototype SpecialChar

" What can make up a variable name
syntax cluster mqlIdentifier contains=mqlVar,mqlObject,mqlConstant,
\                                        mqlPrototype

syntax match mqlAssignmentChar /:/ contained
highlight default link mqlAssignmentChar SpecialChar

syntax match mqlAssignment /@\?\I\%(\i\|::\|\.\)*\s*::\@!/
\                             contains=@mqlIdentifier,mqlAssignmentChar
highlight default link mqlAssignment Identifier

syntax match mqlFunction /->/
syntax match mqlFunction /=>/
syntax match mqlFunction /<-/
syntax match mqlFunction /<-/
highlight default link mqlFunction Function

syntax keyword mqlTodo TODO FIXME XXX contained
highlight default link mqlTodo Todo

syntax region mqlEmbed start=/`/ end=/`/
highlight default link mqlEmbed Special

" Matches numbers like -10, -10e8, -10E8, 10, 10e8, 10E8
syntax match mqlNumber /\<-\?\d\+\%([eE][+-]\?\d\+\)\?\>/
" Matches hex numbers like 0xfff, 0x000
syntax match mqlNumber /\<0[xX]\x\+\>/
highlight default link mqlNumber Number

" Matches floating-point numbers like -10.42e8, 10.42e-8
syntax match mqlFloat /\<-\?\d\+\.\d\+\%([eE][+-]\?\d\+\)\?/
highlight default link mqlFloat Float

syntax region mqlInterpolation matchgroup=mqlInterpDelim
\                                 start=/\${/ end=/}/
\                                 contained contains=TOP
highlight default link mqlInterpDelim Delimiter

syntax match mqlInterpSimple /\$@\?\K\%(\k\|\.\)*/ contained
highlight default link mqlInterpSimple Identifier

syntax match mqlEscape /\\\d\d\d\|\\x\x\{2\}\|\\u\x\{4\}\|\\./ contained
highlight default link mqlEscape SpecialChar

syntax cluster mqlSimpleString contains=@Spell,mqlEscape
syntax cluster mqlInterpString contains=@mqlSimpleString,mqlInterpSimple,
\                                          mqlInterpolation

syntax region mqlRegExp start=/\// skip=/\\\// end=/\/[gimy]\{,4}/ oneline
\                          contains=@mqlInterpString
highlight default link mqlRegExp String

syntax region mqlString start=/"/ skip=/\\\\\|\\"/ end=/"/ contains=@mqlInterpString
syntax region mqlString start=/'/ skip=/\\\\\|\\'/ end=/'/ contains=@mqlSimpleString
highlight default link mqlString String

syntax region mqlHeredoc start=/"""/ end=/"""/ contains=@mqlInterpString
syntax region mqlHeredoc start=/'''/ end=/'''/ contains=@mqlSimpleString
highlight default link mqlHeredoc String

syntax keyword mqlReservedWords bool case default do function var with const enum
\ export import native extern input color datetime double int string void
highlight default link mqlReservedWords Identifier


"+-------------------------------------------------------------------+
"| Comments                                                          |
"+-------------------------------------------------------------------+

" mql4CommentGroup allows adding matches for special things in comments
syn cluster	mql4CommentGroup	contains=mql4Todo,mql4BadContinuation

if exists("c_comment_strings")
  " A comment can contain mql4String, mql4Character and mql4Number.
  " But a "*/" inside a mql4String in a mql4Comment DOES end the comment!  So we
  " need to use a special type of mql4String: mql4CommentString, which also ends on
  " "*/", and sees a "*" at the start of the line as comment again.
  " Unfortunately this doesn't very well work for // type of comments :-(
  syntax match	mql4CommentSkip	contained "^\s*\*\($\|\s\+\)"
  syntax region mql4CommentString	contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end=+\*/+me=s-1 contains=mql4Special,mql4CommentSkip
  syntax region mql4Comment2String	contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end="$" contains=mql4Special
  syntax region  mql4CommentL	start="//" skip="\\$" end="$" keepend contains=@mql4CommentGroup,mql4Comment2String,mql4Character,mql4NumbersCom,mql4SpaceError,@Spell
  if exists("c_no_comment_fold")
    " Use "extend" here to have preprocessor lines not terminate halfway a
    " comment.
    syntax region mql4Comment	matchgroup=mql4CommentStart start="/\*" end="\*/" contains=@mql4CommentGroup,mql4CommentStartError,mql4CommentString,mql4Character,mql4NumbersCom,mql4SpaceError,@Spell extend
  else
    syntax region mql4Comment	matchgroup=mql4CommentStart start="/\*" end="\*/" contains=@mql4CommentGroup,mql4CommentStartError,mql4CommentString,mql4Character,mql4NumbersCom,mql4SpaceError,@Spell fold extend
  endif
else
  syn region	mql4CommentL	start="//" skip="\\$" end="$" keepend contains=@mql4CommentGroup,mql4SpaceError,@Spell
  if exists("c_no_comment_fold")
    syn region	mql4Comment	matchgroup=mql4CommentStart start="/\*" end="\*/" contains=@mql4CommentGroup,mql4CommentStartError,mql4SpaceError,@Spell extend
  else
    syn region	mql4Comment	matchgroup=mql4CommentStart start="/\*" end="\*/" contains=@mql4CommentGroup,mql4CommentStartError,mql4SpaceError,@Spell fold extend
  endif
endif
" keep a // comment separately, it terminates a preproc. conditional
syntax match	mql4CommentError	display "\*/"
syntax match	mql4CommentStartError display "/\*"me=e-1 contained

hi def link mql4Comment		Comment
hi def link mql4CommentString	mql4String
hi def link mql4Comment2String	mql4String
hi def link mql4CommentSkip	mql4Comment
hi def link mql4CommentError	mql4Error
hi def link mql4CommentStartError	mql4Error
hi def link mql4CommentL		mql4Comment
hi def link mql4CommentStart	mql4Comment
