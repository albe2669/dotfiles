{pkgs, pkgs-unstable, ...}: {
  home.packages = with pkgs; [
    teams-for-linux
    slack
    pkgs-unstable._1password-gui
    pkgs-unstable._1password-cli
  ];
}
