{
  config,
  lib,
  ...
}: {
  home.file."${config.opts.variables.homeDirectory.path}/.ideavimrc" = {
    text =
      ''
        set ideavimr
        """ Map leader to space ---------------------
        let mapleader="\"

        """ Plugins  --------------------------------
        set surround
        set multiple-cursors
        set commentary
        set argtextobj
        set easymotion
        set textobj-entire
        set ReplaceWithRegister

        """ Plugin settings -------------------------
        let g:argtextobj_pairs="[:],(:),<:>"

        """ Common settings -------------------------
        set showmode
        set so=5
        set incsearch
        set nu

        """ Idea specific settings ------------------
        set ideajoin
        set ideastatusicon=gray
        set idearefactormode=keep

        """ New keybindings -------------------------
        " gw : Swap word with next word
        nmap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<cr><c-o><c-l>

        """ Custom keybindings ----------------------
        " Go to definition
        nnoremap gd :action GotoDeclaration<CR>

        " Rename
        nnoremap <Leader>lr :action RenameElement<CR>

        " Code action/quick fix
        nnoremap <Leader>la :action ShowIntentionActions<CR>

        " Show line diagnostics
        nnoremap <Leader>ld :action ShowErrorDescription<CR>

        " Signature help (insert mode)
        inoremap <Leader>lh <C-o>:action ParameterInfo<CR>
      ''
      + lib.optionalString config.opts.variables.isDarwin ''
        " .ideavimrc
        " Remap every default Vim/IdeaVim Ctrl shortcut to the Mac Command key (⌘)
        " <D-*> is IdeaVim's notation for the Command key.

        " ─────────────────────────────────────────────────────────────────────────────
        " NORMAL MODE
        " ─────────────────────────────────────────────────────────────────────────────

        " <C-a>  Increment number under cursor
        noremap <D-a> <C-a>

        " <C-x>  Decrement number under cursor
        noremap <D-x> <C-x>

        " <C-b>  Scroll one page backward (up)
        noremap <D-b> <C-b>

        " <C-f>  Scroll one page forward (down)
        noremap <D-f> <C-f>

        " <C-u>  Scroll half-page up
        noremap <D-u> <C-u>

        " <C-d>  Scroll half-page down
        noremap <D-d> <C-d>

        " <C-e>  Scroll window down one line (without moving cursor)
        noremap <D-e> <C-e>

        " <C-y>  Scroll window up one line (without moving cursor)
        noremap <D-y> <C-y>

        " <C-g>  Show file name / status
        noremap <D-g> <C-g>

        " <C-o>  Jump to older position in jump list
        noremap <D-o> <C-o>

        " <C-i>  Jump to newer position in jump list (same as <Tab>)
        noremap <D-i> <C-i>

        " <C-]>  Jump to tag / go to definition
        noremap <D-]> <C-]>

        " <C-t>  Pop tag from stack (go back after <C-]>)
        noremap <D-t> <C-t>

        " <C-r>  Redo
        noremap <D-r> <C-r>

        " <C-w>  Window command prefix (splits, focus, resize...)
        noremap <D-w> <C-w>

        " <C-v>  Enter Visual Block mode
        noremap <D-v> <C-v>

        " <C-q>  Enter Visual Block mode (alternative)
        noremap <D-q> <C-q>

        " <C-z>  Suspend / background Vim (no-op in IdeaVim, kept for completeness)
        noremap <D-z> <C-z>

        " <C-l>  Redraw screen / clear search highlight in IdeaVim
        noremap <D-l> <C-l>

        " <C-n>  Move to next match / next completion item
        noremap <D-n> <C-n>

        " <C-p>  Move to previous match / previous completion item
        noremap <D-p> <C-p>

        " <C-^>  Switch to alternate (previously edited) file
        noremap <D-^> <C-^>

        " <C-6>  Same as <C-^> on keyboards without ^
        noremap <D-6> <C-6>

        " ─────────────────────────────────────────────────────────────────────────────
        " INSERT MODE
        " ─────────────────────────────────────────────────────────────────────────────

        " <C-a>  Insert previously inserted text
        inoremap <D-a> <C-a>

        " <C-e>  Insert character below cursor
        inoremap <D-e> <C-e>

        " <C-y>  Insert character above cursor
        inoremap <D-y> <C-y>

        " <C-d>  De-indent current line (one shiftwidth)
        inoremap <D-d> <C-d>

        " <C-t>  Indent current line (one shiftwidth)
        inoremap <D-t> <C-t>

        " <C-f>  Re-indent current line (per indentexpr)
        inoremap <D-f> <C-f>

        " <C-h>  Delete character before cursor (like Backspace)
        inoremap <D-h> <C-h>

        " <C-j>  Insert newline (like Enter)
        inoremap <D-j> <C-j>

        " <C-m>  Insert newline (like Enter / Return)
        inoremap <D-m> <C-m>

        " <C-k>  Enter a digraph
        inoremap <D-k> <C-k>

        " <C-n>  Next keyword completion
        inoremap <D-n> <C-n>

        " <C-p>  Previous keyword completion
        inoremap <D-p> <C-p>

        " <C-o>  Execute one Normal-mode command then return to Insert mode
        inoremap <D-o> <C-o>

        " <C-r>  Insert contents of a register ({0-9a-z"%#*+:.-=})
        inoremap <D-r> <C-r>

        " <C-u>  Delete all entered characters on current line (back to indent)
        inoremap <D-u> <C-u>

        " <C-w>  Delete the word before the cursor
        inoremap <D-w> <C-w>

        " <C-v>  Insert next character literally / escape special chars
        inoremap <D-v> <C-v>

        " <C-q>  Same as <C-v> on some terminals
        inoremap <D-q> <C-q>

        " <C-x>  Enter insert-completion sub-mode
        inoremap <D-x> <C-x>

        " <C-]>  Trigger abbreviation expansion (without inserting a space)
        inoremap <D-]> <C-]>

        " <C-z>  Suspend (no-op in IdeaVim)
        inoremap <D-z> <C-z>

        " <C-[>  Escape — exit Insert mode (equivalent to <Esc>)
        inoremap <D-[> <C-[>

        " ─────────────────────────────────────────────────────────────────────────────
        " VISUAL / SELECT MODE
        " ─────────────────────────────────────────────────────────────────────────────

        " <C-a>  Increment numbers in selection
        vnoremap <D-a> <C-a>

        " <C-x>  Decrement numbers in selection
        vnoremap <D-x> <C-x>

        " <C-b>  Scroll page backward
        vnoremap <D-b> <C-b>

        " <C-f>  Scroll page forward
        vnoremap <D-f> <C-f>

        " <C-g>  Toggle between Visual and Select mode
        vnoremap <D-g> <C-g>

        " <C-]>  Jump to tag in Visual mode
        vnoremap <D-]> <C-]>

        " ─────────────────────────────────────────────────────────────────────────────
        " COMMAND-LINE MODE
        " Note: <D-*> support in command-line mode may be limited in IdeaVim
        " ─────────────────────────────────────────────────────────────────────────────

        " <C-b>  Move cursor to beginning of command line
        cnoremap <D-b> <C-b>

        " <C-e>  Move cursor to end of command line
        cnoremap <D-e> <C-e>

        " <C-h>  Delete character before cursor (Backspace)
        cnoremap <D-h> <C-h>

        " <C-w>  Delete word before cursor
        cnoremap <D-w> <C-w>

        " <C-u>  Delete from cursor to start of command line
        cnoremap <D-u> <C-u>

        " <C-r>  Insert register contents on command line
        cnoremap <D-r> <C-r>

        " <C-f>  Open command-line window (edit history)
        cnoremap <D-f> <C-f>

        " <C-n>  Next command in history
        cnoremap <D-n> <C-n>

        " <C-p>  Previous command in history
        cnoremap <D-p> <C-p>

        " <C-v>  Insert next character literally
        cnoremap <D-v> <C-v>

        " <C-]>  Trigger abbreviation
        cnoremap <D-]> <C-]>
      '';
  };
}
