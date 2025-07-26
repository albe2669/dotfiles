{...}: {
  imports = [
    ../../home/common.nix
    ../../home/alacritty
    ../../home/betterlockscreen
    ../../home/dunst
    ../../home/eww
    ../../home/fish
    ../../home/git
    ../../home/i3
    ../../home/hyprland
    ../../home/kitty
    ../../home/lazydocker
    ../../home/lazygit
    ../../home/nvim
    (import ../../home/picom {nvidiaDrivers = true;})
    ../../home/polybar
    ../../home/yazi
    ../../home/rofi
    ../../home/sioyek
    ../../home/wallpapers
    ../../home/zathura

    ../../home/k8.nix
    ../../home/langs.nix
    ../../home/python3.nix
    ../../home/tex.nix

    ../../home/anytype.nix
    ../../home/bluetooth.nix
    ../../home/direnv.nix
    ../../home/gcloud.nix
    ../../home/hidpi.nix
    ../../home/libreoffice.nix
    ../../home/obs.nix
    ../../home/jetbrains.nix
    ../../home/php.nix
    ../../home/programs.nix
    ../../home/spacedrive.nix
    ../../home/tmux.nix
    ../../home/todo.nix
    ../../home/guiutils.nix
    ../../home/utils.nix
    ../../home/vscode.nix
    ../../home/work.nix
    ../../home/zen.nix
  ];
}
