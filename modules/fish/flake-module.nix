{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "nix-env";
        src = pkgs.fetchFromGitHub {
          owner = "lilyball";
          repo = "nix-env.fish";
          rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
          sha256 = "sha256-LV5NiHfg4JOrcjW7hAasUSukT43UBNXGPi1oZWPbnCA="; # Set to empty to get the right sha from the error output
        };
      }
    ];

    shellAliases = {
      hms = "home-manager switch";
    };

    shellAbbrs = {
      n = "nvim";
      g = "git";
    };
  
    shellInit = ''
      # Move these to a separate file intended for arch-gosling
      set GDK_SCALE 2
      set GDK_DPI_SCALE 0.5
      set QT_AUTO_SCREEN_SCALE_FACTOR 1

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

      jump shell fish | source

      # The next line updates PATH for the Google Cloud SDK.
      if [ -f '/home/goose/Downloads/gcloud/google-cloud-sdk/path.fish.inc' ]; . '/home/goose/Downloads/gcloud/google-cloud-sdk/path.fish.inc'; end
    '';
  };

  home.packages = with pkgs; [
    fishPlugins.bass
  ];

  xdg.configFile.fish = {
    source = ./config;
    recursive = true;
  };
}
