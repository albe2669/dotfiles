{username, ...}: {
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";
  };

  programs.home-manager.enable = true;

  imports = [
    ../../home/alacritty
    ../../home/dunst
    ../../home/fish
    ../../home/git
    ../../home/i3
    ../../home/kitty
    ../../home/lazygit
    ../../home/nvim
    (import ../../home/picom (
      { nvidiaDrivers = false; }
    ))
    ../../home/polybar
    ../../home/rofi
    ../../home/wallpapers
    ../../home/zathura

    ../../home/langs.nix
    ../../home/python3.nix

    ../../home/tmux.nix
    ../../home/utils.nix
    ../../home/vscode.nix
  ];
}
