{ pkgs, ... }: {
  home.packages = with pkgs; [
    polybar
  ];

  xdg.configFile.polybar = {
    source = ./config;
    recursive = true;
  };
}
