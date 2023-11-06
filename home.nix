{ ... }:

{
  home.username = "goose";
  home.homeDirectory = "/home/goose";
  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

  programs.bat = {
    enable = true;
    config = {
      theme = "GitHub";
      italic-text = "always";
    };
  };

  imports = [
    ./modules/fish/flake-module.nix
    ./modules/git/flake-module.nix
    ./modules/kitty/flake-module.nix
    ./modules/langs.nix
    ./modules/lazygit/flake-module.nix
    ./modules/nvim/flake-module.nix
    ./modules/obsidian/flake-module.nix
    ./modules/python3.nix
    ./modules/tmux/flake-module.nix
    ./modules/utils.nix
    ./modules/vscode.nix
    ./modules/zathura/flake-module.nix
  ];
}
