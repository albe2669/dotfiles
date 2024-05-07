{...}: {
  imports = [
    ../../home/common.nix
    ../../home/alacritty
    ../../home/betterlockscreen
    ../../home/dunst
    ../../home/fish
    ../../home/git
    ../../home/i3
    ../../home/kitty
    ../../home/lazygit
    ../../home/nvim
    (import ../../home/picom {nvidiaDrivers = true;})
    ../../home/polybar
    ../../home/rofi
    ../../home/wallpapers
    ../../home/zathura

    ../../home/k8.nix
    ../../home/langs.nix
    ../../home/python3.nix

    ../../home/obs.nix
    ../../home/programs.nix
    ../../home/tmux.nix
    ../../home/utils.nix
    ../../home/vscode.nix
  ];
}
