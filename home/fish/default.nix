{pkgs, ...}: {
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "nix-env";
        src = pkgs.fetchFromGitHub {
          owner = "lilyball";
          repo = "nix-env.fish";
          rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
          sha256 = "sha256-RG/0rfhgq6aEKNZ0XwIqOaZ6K5S4+/Y5EEMnIdtfPhk="; # Set to empty to get the right sha from the error output
        };
      }
    ];

    shellAliases = {
      hms = "home-manager switch";
      ls = "exa";
      ll = "exa -l";
      cat = "bat";
    };

    shellAbbrs = {
      n = "nvim";
      g = "git";
      j = "z";
      hm = "home-manager";
    };

    shellInit = ''
      # Go stuff
      set -x GOPATH $HOME/.local/go

      # Path
      fish_add_path /usr/local/go/bin
      fish_add_path /usr/local/texlive/2022/bin/x86_64-linux

      fish_add_path $HOME/.local/bin
      fish_add_path $HOME/.local/go/bin
      fish_add_path $HOME/.cargo/bin


      fish_add_path $HOME/Documents/Installs/bin
      fish_add_path $HOME/Documents/Installs/nvim
      fish_add_path $HOME/Documents/Installs/lazygit
      fish_add_path $HOME/Documents/Installs/kubectl
      fish_add_path $HOME/Documents/Installs/kustomize
      fish_add_path $HOME/Documents/Installs/kind
      fish_add_path $HOME/Documents/Installs/dagger/bin
      fish_add_path $HOME/Documents/Installs/rust_analyzer
      fish_add_path $HOME/Documents/Installs/zotero
      fish_add_path $HOME/Documents/Installs/google-cloud-sdk/bin
      fish_add_path $HOME/Documents/Installs/lsp/lua/bin

      fish_add_path $HOME/Documents/Installs/zotero

      # The next line updates PATH for the Google Cloud SDK.
      if [ -f '/home/goose/Downloads/gcloud/google-cloud-sdk/path.fish.inc' ]; . '/home/goose/Downloads/gcloud/google-cloud-sdk/path.fish.inc'; end

      zoxide init fish | source
    '';
  };

  home.packages = with pkgs; [
    fishPlugins.bass
    fishPlugins.puffer
    fishPlugins.async-prompt
  ];

  xdg.configFile.fish = {
    source = ./config;
    recursive = true;
  };
}
