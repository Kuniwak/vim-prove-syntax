" Vim syntax file
" Language:   Verbose Prove Output
" Maintainer: Kuniwak (orga.chem.job@gmail.com)
" Remark:     High level visilibity syntax for TAP by prove-output verbose output.
" License:    MIT

if !exists('main_syntax')
  if version < 600
    syntax clear
  elseif exists('b:current_syntax')
    finish
  endif
  let main_syntax = 'prove-output'
endif

"" Drop fold if it is set but VIM doesn't support it.
let b:prove_output_fold='true'
if version < 600    " Don't support the old version
  unlet! b:prove_output_fold
endif

syn match proveOutputLine              /^\s*\(not \)\?ok\s.*/me=s contains=proveOutputOk,proveOutputNotOK,proveOutputSkipped
syn match proveOutputOK                /\s*ok [0-9]\+ -/me=e-1 contained
syn match proveOutputNotOK             /\s*not ok [0-9]\+ -/me=e-1 contained
syn match proveOutputSkipped           /\s*ok [0-9]\+ # skip/me=e-6 contained

syn match proveOutputDetaDumper        /^\$VAR[0-9]\+/

syn match proveOutputPlanLine          /^\s*[0-9]\+\.\.[0-9]\+.*/me=s contains=proveOutputPlan
syn match proveOutputPlan              /\s*[0-9]\+\.\.[0-9]\+/ contained nextgroup=proveOutputComment

syn match proveOutputCommentLine       /^\s*#.*/me=s contains=proveOutputComment
syn match proveOutputComment           /\s*#.*/ contained contains=proveOutputAssertionGot,proveOutputAssertionExpected
syn match proveOutputAssertionGot      /got:.*/hs=s+4 contained
syn match proveOutputAssertionExpected /expected:.*/hs=s+9 contained

syn match proveOutputResult            /^\s*Result:/ nextgroup=proveOutputPass,proveOutputFail skipwhite
syn keyword proveOutputPass            PASS contained
syn keyword proveOutputFail            FAIL FAILED contained

syn match proveOutputFilePath          /at \S* line [0-9]\+/ms=s+3

syn region proveOutputRegion     start=/^\(not \)\?ok/ end=/^\(\(not \)\?ok\|All tests successful\.\|Dubious, test returned [0-9]\+\|Bailout called\.\)/me=s-1 fold transparent excludenl

set foldminlines=5
set foldcolumn=2
set foldenable
set foldmethod=syntax
syn sync fromstart

if !exists('did_proveoutput_syntax_inits')
  let did_proveoutput_syntax_inits = 1

  " Define the default highlighting.
  " For version 5.7 and earlier: only when not done already
  " For version 5.8 and later: only when an item doesn't have highlighting yet
  if version >= 508 || !exists('did_prove_output_syn_inits')
    if version < 508
      let did_prove_output_syn_inits = 1
      command -nargs=+ HiLink hi link <args>
    else
      command -nargs=+ HiLink hi def link <args>
    endif

    HiLink proveOutputOK                SpecialChar
    HiLink proveOutputNotOK             Error
		HiLink proveOutputSkipped           Function
    HiLink proveOutputPlan              Comment
    HiLink proveOutputRegion            Normal
    HiLink proveOutputResult            Comment
    HiLink proveOutputPass              SpecialChar
    HiLink proveOutputFail              Error
    HiLink proveOutputComment           Comment
		HiLink proveOutputAssertionGot      Error
		HiLink proveOutputAssertionExpected SpecialChar
		HiLink proveOutputFilePath          Error
		HiLink proveOutputDetaDumper        Constant
    delcommand HiLink
  endif
endif

let b:current_syntax = "prove-output"
if main_syntax == 'prove-output'
  unlet main_syntax
endif
