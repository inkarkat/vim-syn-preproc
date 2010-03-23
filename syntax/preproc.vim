" Vim syntax extension file
" Language:	C preprocessor syntax on top of c, cpp, ...
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" REVISION	DATE		REMARKS 
"	001	24-Mar-2010	file creation

if exists('b:current_syntax') && b:current_syntax =~# 'preproc'
    finish
endif

syn cluster preprocNativeComments contains=ovfpComment
syn cluster preprocNativeCommentGroup contains=@ovfpCommentGroup

syn region	preprocIncluded	display start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match	preprocIncluded	display "<[^>]*>"
syn match	preprocInclude	display "^\s*\%(%:\|#\)\s*include\>\s*["<]" contains=preprocIncluded
syn cluster	preprocPreProcGroup	contains=preprocIncluded,preprocInclude,preprocDefine
syn region	preprocDefine		start="^\s*\%(%:\|#\)\s*\(define\|undef\)\>" skip="\\$" end="$" keepend containedin=@preprocNativeCommentGroup contains=ALLBUT,@preprocNativeComments,@preprocPreProcGroup,@Spell
syn region	preprocPreProc		start="^\s*\%(%:\|#\)\s*\(pragma\>\|line\>\|warning\>\|warn\>\|error\>\)" skip="\\$" end="$" keepend containedin=@preprocNativeCommentGroup contains=ALLBUT,@preprocNativeComments,@preprocPreProcGroup,@Spell

syn region	preprocPreCondit	start="^\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\|elif\)\>" skip="\\$" end="$" end="//"me=s-1
syn match	preprocPreCondit	display "^\s*\(%:\|#\)\s*\(else\|endif\)\>"
if ! exists('preproc_no_if0')
  if ! exists('preproc_no_if0_fold')
    syn region	preprocCppOut		start="^\s*\(%:\|#\)\s*if\s\+0\+\>" end=".\@=\|$" contains=preprocCppOut2 fold
  else
    syn region	preprocCppOut		start="^\s*\(%:\|#\)\s*if\s\+0\+\>" end=".\@=\|$" contains=preprocCppOut2
  endif
  syn region	preprocCppOut2	contained start="0" end="^\s*\(%:\|#\)\s*\(endif\>\|else\>\|elif\>\)" contains=preprocCppSkip
  syn region	preprocCppSkip	contained start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" contains=preprocCppSkip
endif


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


hi def link preprocDefine	Macro
hi def link preprocInclude	Include
hi def link preprocIncluded	String
hi def link preprocPreProc	PreProc
hi def link preprocPreCondit	PreCondit
hi def link preprocCppSkip	preprocCppOut
hi def link preprocCppOut2	preprocCppOut
hi def link preprocCppOut	Comment


if !exists('b:current_syntax')
    let b:current_syntax = "preproc"
else
    let b:current_syntax .= '.preproc'
endif

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
