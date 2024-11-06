{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libreoffice-qt
  ];
}
