PREPROC SYNTAX
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

This syntax extension highlights C preprocessor directives and (optionally)
folds preprocessor conditions. You can use this as a standalone syntax, or add
this on top of another filetype.

USAGE
------------------------------------------------------------------------------

    If you have certain files of a particular filetype (e.g. Tcl) that contain
    preprocessing directives, you can add a custom filetype detection (here: for a
    "Tcl template" .tclt file extension; cp. new-filetype), and set a compound
    filetype:
        autocmd BufNewFile,BufRead *.tclt setf tcl.preproc

    To add the highlighting to the file's existing syntax, use:
        :setf <C-R>=&filetype<CR>.preproc

    To just have preprocessing highlighting (and no other syntax), use:
        :setlocal syntax=preproc

    Note: This script supports both the normal "#..." syntax as well as the
    alternative "%:..." digraph (or alternative token) for the '#' punctuator.

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-syn-preproc
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim syn-preproc*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

C/C++-style comments are typically removed by the preprocessor and thus
highlighted as other comments. You can define a different highlighting if you
want to visually distinguish them from the default comments of that filetype:

    hi link preprocComment NonText

Or turn highlighting of comments off:

    let preproc_no_comments = 1

Multi-line C-style comments are folded; if you do not want this, use:

    let preproc_no_comment_fold = 1

To turn off folding of #if ... #endif conditions, use:

    :let preproc_no_fold_conditions = 1

Lines commented out via #if 0 will still be folded. To turn that of, too,
use:

    :let preproc_no_if0_fold = 1

To completely turn off highlighting (as comments) of #if 0 blocks, use:

    :let preproc_no_if0 = 1

LIMITATIONS
------------------------------------------------------------------------------

- Highlighting does not work with all syntax scripts; some syntax groups may
  obscure preprocessing matches, and preprocessing directives can negatively
  impact the matching of the original syntax.

### CONTRIBUTING

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-syn-preproc/issues or email (address below).

HISTORY
------------------------------------------------------------------------------

##### 1.00    17-Nov-2016
- First published version.

##### 0.01    24-Mar-2010
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2010-2022 Ingo Karkat -
Based on the C Vim syntax file by Bram Moolenaar -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
