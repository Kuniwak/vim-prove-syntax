" Vim syntax file
" Language:   Verbose Prove Output
" Maintainer: Kuniwak (orga.chem.job@gmail.com)
" Remark:     High level visilibity syntax for TAP by prove verbose output.
" License:    MIT

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'prove'
endif

"" Drop fold if it is set but VIM doesn't support it.
let b:prove_fold='true'
if version < 600    " Don't support the old version
  unlet! b:prove_fold
endif

syn match proveTestLine              /^\s*\(not \)\?ok\s.*/me=s contains=proveTestOk,proveTestNotOK,proveTestSkipped
syn match proveTestOK                /\s*ok [0-9]\+ -/me=e-1 contained
syn match proveTestNotOK             /\s*not ok [0-9]\+ -/me=e-1 contained
syn match proveTestSkipped           /\s*ok [0-9]\+ # skip/me=e-6 contained

syn match proveTestDetaDumper        /^\$VAR[0-9]\+/

syn match proveTestPlanLine          /^\s*[0-9]\+\.\.[0-9]\+.*/me=s contains=proveTestPlan
syn match proveTestPlan              /\s*[0-9]\+\.\.[0-9]\+/ contained nextgroup=proveTestComment

syn match proveTestCommentLine       /^\s*#.*/me=s contains=proveTestComment
syn match proveTestComment           /\s*#.*/ contained contains=proveTestAssertionGot,proveTestAssertionExpected
syn match proveTestAssertionGot      /got:.*/hs=s+4 contained
syn match proveTestAssertionExpected /expected:.*/hs=s+9 contained

syn match proveTestResult            /^\s*Result:/ nextgroup=proveTestPass,proveTestFail skipwhite
syn keyword proveTestPass            PASS contained
syn keyword proveTestFail            FAIL FAILED contained

syn match proveTestFilePath          /at \/\S* line [0-9]\+/ms=s+3

syn region proveTestRegion     start=/^\(not \)\?ok/ end=/^\(\(not \)\?ok\|All tests successful\.\|Dubious, test returned [0-9]\+\|Bailout called\.\)/me=s-1 fold transparent excludenl

set foldminlines=5
set foldcolumn=2
set foldenable
set foldmethod=syntax
syn sync fromstart

if !exists("did_proveverboseoutput_syntax_inits")
  let did_proveverboseoutput_syntax_inits = 1

  " Define the default highlighting.
  " For version 5.7 and earlier: only when not done already
  " For version 5.8 and later: only when an item doesn't have highlighting yet
  if version >= 508 || !exists("did_prove_syn_inits")
    if version < 508
      let did_prove_syn_inits = 1
      command -nargs=+ HiLink hi link <args>
    else
      command -nargs=+ HiLink hi def link <args>
    endif

    HiLink proveTestOK                SpecialChar
    HiLink proveTestNotOK             Error
		HiLink proveTestSkipped           Function
    HiLink proveTestPlan              Comment
    HiLink proveTestRegion            Normal
    HiLink proveTestResult            Comment
    HiLink proveTestPass              SpecialChar
    HiLink proveTestFail              Error
    HiLink proveTestComment           Comment
		HiLink proveTestAssertionGot      Error
		HiLink proveTestAssertionExpected SpecialChar
		HiLink proveTestFilePath          Error
		HiLink proveTestDetaDumper        Constant
    delcommand HiLink
  endif
endif

let b:current_syntax = "prove"
if main_syntax == 'prove'
  unlet main_syntax
endif
