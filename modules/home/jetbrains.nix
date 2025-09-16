{
  config,
  system,
  pkgs-unstable,
  inputs,
  ...
}: let
  overrideIde = jetbrains: ide:
    jetbrains."${ide}".override {
      vmopts = ''
        -Dawt.toolkit.name=WLToolkit
      '';
    };

  createIde = jetbrains: ide-name: let
    ide = overrideIde jetbrains ide-name;
  in
    jetbrains.plugins.addPlugins ide ([
        "github-copilot"
      ]
      ++ builtins.map (p: inputs.nix-jetbrains-plugins.plugins."${system}"."${ide.pname}"."${ide.version}"."${p}") [
        "IdeaVIM"
        "dev.turingcomplete.intellijdevelopertoolsplugins"
        "com.intellij.resharper.azure"
        "mobi.hsz.idea.gitignore"
        "com.github.catppuccin.jetbrains"
        "com.github.catppuccin.jetbrains_icons"
        "com.intellij.lang.jsgraphql"
      ]);
in {
  home.packages = with pkgs-unstable; [
    (createIde jetbrains "rider")
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
