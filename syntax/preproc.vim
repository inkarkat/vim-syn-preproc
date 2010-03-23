" Vim syntax extension file
" Language:	C preprocessor syntax on top of c, cpp, ...
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" DESCRIPTION:
"   This syntax extension highlights C preprocessor directives and (optionally)
"   folds preprocessor conditions. 
"
" USAGE:
"   To add the highlighting to the file's existing syntax, use: 
"	:setf <C-R>=&filetype<CR>.preproc
"
" CONFIGURATION:
"   To turn off folding of #if ... #endif conditions, use: 
"	:let preproc_no_fold_conditions = 1
"   Lines commented out via #if 0 will still be folded. To turn that of, too,
"   use: 
"	:let preproc_no_if0_fold = 1
"   To completely turn off highlighting (as comments) of #if 0 blocks, use: 
"	:let preproc_no_if0 = 1
"
" NOTES:
"   This script supports both the normal "#..." syntax as well as the
"   alternative "%:..." digraph (or alternative token) for the '#' punctuator. 
"
" REVISION	DATE		REMARKS 
"	001	24-Mar-2010	file creation

if exists('b:current_syntax') && b:current_syntax =~# 'preproc'
    finish
endif


" Many filetypes have comments that start with a # and go until the end of the
" line: Unix shell, Perl, Unix config files, ...
" The corresponding syntax file will then define a syntax group for comments,
" and our preprocessor definitions then will never match, because our groups are
" not included in theirs. The same happens the other way around: Our
" preprocDefine and preprocPreProc groups include all existing syntax groups
" (e.g. to continue highlighting C keywords in a complex, multi-line C macro),
" but their comment group may override our highlighting for the preprocessor
" keyword. 
" If the syntax file defines a {filetype}CommentGroup syntax cluster to add
" custom highlighting inside comments (a common idiom), we can add our
" groups via the preprocNativeCommentGroup cluster to it and have thus our
" preprocessor stuff matched. 
" If the syntax file uses standard naming {filetype}Comment for their comments,
" we can add it to our preprocNativeComment cluster, and thus avoid that their
" comment overrides our highlighting of the preprocessor directive. 
" Note that we cannot use their {filetype}CommentGroup for the latter one, but
" must use the actual syntax group; otherwise, the recursive inclusion will
" cancel itself out (?!) and the native comment highlighting will prevail.  
"
" Some scripts are not that well-behaved; for those filetypes, we can add
" special workarounds to after/syntax/preproc.vim. 
"
"syn cluster preprocNativeComment contains=ovfpComment
function! s:AddToCluster( syntax, bareGroup )
    let l:syntaxGroup = a:syntax . a:bareGroup
    if hlID(l:syntaxGroup)
	execute 'syn cluster preprocNative' . a:bareGroup 'add=' . l:syntaxGroup
echomsg 'syn cluster preprocNative' . a:bareGroup 'add=' . l:syntaxGroup
    endif
endfunction
function! s:IncludeNativeComments()
    for l:syntax in split(b:current_syntax, '\.')
	call s:AddToCluster(l:syntax, 'Comment')
    endfor
endfunction
if exists('b:current_syntax')
    " Note: I would be nice to also check whether &comments =~# ':#', but the
    " ftplugin script is only sourced after the syntax script! 
    "call s:IncludeNativeComments()
endif


syn region	preprocIncluded	display start=+"+ skip=+\\\\\|\\"+ end=+"+ contained
syn match	preprocIncluded	display "<[^>]*>" contained
syn match	preprocInclude	display "^\s*\%(%:\|#\)\s*include\>\s*["<]" contains=preprocIncluded
syn cluster	preprocPreProcGroup	contains=preprocIncluded,preprocInclude,preprocDefine

" Use matchgroup here to have the preprocessor directive always highlighted as
" such, regardless of any native matching after that. 
syn region	preprocDefine		matchgroup=preprocDefine start="^\s*\%(%:\|#\)\s*\(define\|undef\)\>" skip="\\$" end="$" keepend contains=ALLBUT,@preprocNativeComment,@preprocPreProcGroup,@Spell
syn region	preprocPreProc		matchgroup=preprocPreProc start="^\s*\%(%:\|#\)\s*\(pragma\>\|line\>\|warning\>\|warn\>\|error\>\)" skip="\\$" end="$" keepend contains=ALLBUT,@preprocNativeComment,@preprocPreProcGroup,@Spell

syn region	preprocPreCondit	start="^\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\|elif\)\>" skip="\\$" end="$" end="//"me=s-1
syn match	preprocPreCondit	display "^\s*\(%:\|#\)\s*\(else\|endif\)\>"
if ! exists('preproc_no_if0')
    if ! exists('preproc_no_if0_fold') && exists('preproc_no_fold_conditions')
	syn region	preprocCppOut		start="^\s*\(%:\|#\)\s*if\s\+0\+\>" end=".\@=\|$" contains=preprocCppOut2 fold
    else
	syn region	preprocCppOut		start="^\s*\(%:\|#\)\s*if\s\+0\+\>" end=".\@=\|$" contains=preprocCppOut2
    endif
    syn region	preprocCppOut2	contained start="^\s*\(%:\|#\)\s*if\s\+\zs0" end="^\s*\(%:\|#\)\s*\(endif\>\|else\>\|elif\>\)" contains=preprocCppSkip
    syn region	preprocCppSkip	contained start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" contains=preprocCppSkip
endif


if ! exists('preproc_no_fold_conditions')
    " Source: http://groups.google.com/group/vim_use/browse_thread/thread/49ed223185b6cb07
    " fold #if...#else...#endif constructs
    syn region preprocIfFoldContainer
	\ start="^\s*\%(%:\|#\)\s*if\(n\?def\)\?\>"
	\ end="#\s*endif\>"
	\ skip=+"\%(\\"\|[^"]\)\{-}\\\@<!"\|'[^']\{-}'\|'\\''\|//.*+
	\ transparent
	\ keepend extend
	\ containedin=NONE
	\ contains=preprocSynFoldIf,preprocSynFoldElif,preprocSynFoldElse
    syn region preprocSynFoldIf
	\ start="^\s*\%(%:\|#\)\s*if\(n\?def\)\?\>"
	\ end="^\s*\%(%:\|#\)\s*el\(se\|if\)\>"ms=s-1,me=s-1
	\ skip=+"\%(\\"\|[^"]\)\{-}\\\@<!"\|'[^']\{-}'\|'\\''\|//.*+
	\ fold transparent
	\ keepend
	\ contained
	\ nextgroup=preprocSynFoldElif,preprocSynFoldElse
	\ contains=TOP
    syn region preprocSynFoldElif
	\ start="^\s*\%(%:\|#\)\s*elif\>"
	\ end="^\s*\%(%:\|#\)\s*el\(se\|if\)\>"ms=s-1,me=s-1
	\ skip=+"\%(\\"\|[^"]\)\{-}\\\@<!"\|'[^']\{-}'\|'\\''\|//.*+
	\ fold transparent
	\ keepend
	\ contained
	\ nextgroup=preprocSynFoldElse
	\ contains=TOP
    syn region preprocSynFoldElse
	\ start="^\s*\%(%:\|#\)\s*else\>"
	\ end="^\s*\%(%:\|#\)\s*endif\>"
	\ skip=+"\%(\\"\|[^"]\)\{-}\\\@<!"\|'[^']\{-}'\|'\\''\|//.*+
	\ fold transparent
	\ keepend
	\ contained
	\ contains=TOP
endif


hi def link preprocDefine	Macro
hi def link preprocInclude	Include
hi def link preprocIncluded	String
hi def link preprocPreProc	PreProc
hi def link preprocPreCondit	PreCondit
hi def link preprocCppSkip	preprocCppOut
hi def link preprocCppOut2	preprocCppOut
hi def link preprocCppOut	Comment


if ! exists('b:current_syntax')
    let b:current_syntax = 'preproc'
else
    let b:current_syntax .= '.preproc'
endif

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
