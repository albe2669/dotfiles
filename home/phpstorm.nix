{variables, pkgs-unstable, ...}: {
  home.packages = with pkgs-unstable; [
    (jetbrains.plugins.addPlugins pkgs-unstable.jetbrains.phpstorm [
      "github-copilot"
    ])
  ];

  home.file."${variables.homeDirectory.path}/.ideavimrc" = {
    text = ''
      set ideavimr""" Map leader to space ---------------------
      let mapleader=" "

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
    '';
  };
}
