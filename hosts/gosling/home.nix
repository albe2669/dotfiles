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
    ../../home/yazi
    ../../home/rofi
    ../../home/wallpapers
    ../../home/zathura

    ../../home/k8.nix
    ../../home/langs.nix
    ../../home/python3.nix
    ../../home/tex.nix

    ../../home/anytype.nix
    ../../home/bluetooth.nix
    ../../home/gcloud.nix
    ../../home/libreoffice.nix
    ../../home/obs.nix
    ../../home/phpstorm.nix
    ../../home/php.nix
    ../../home/programs.nix
    ../../home/spacedrive.nix
    ../../home/tmux.nix
    ../../home/todo.nix
    ../../home/utils.nix
    ../../home/vscode.nix

    ../../home/courses/htmaa.nix
  ];
}
