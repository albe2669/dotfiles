{
  config,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs-unstable; [
    (jetbrains.plugins.addPlugins jetbrains.phpstorm [
      "github-copilot"
    ])
    (jetbrains.plugins.addPlugins jetbrains.rider [
      "github-copilot"
    ])
  ];

  home.file."${config.opts.variables.homeDirectory.path}/.ideavimrc" = {
    text = ''
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
    '';
  };
}
