{pkgs, ...}: {
  home.packages = with pkgs; [
    alacritty
  ];

  # TODO: Coloring
  xdg.configFile.alacritty = {
    source = ./config;
    recursive = true;
  };
}
