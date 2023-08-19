{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zathura
  ];

  xdg.configFile.zathura = {
    source = ./config;
    recursive = true;
  };
}
