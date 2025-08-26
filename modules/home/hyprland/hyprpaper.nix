{
  self,
  config,
  pkgs,
  ...
}: let 
  path = "${config.xdg.configHome}/wallpapers/misty_forest.jpg";
in {
  imports = [
    self.homeModules.wallpapers
  ];

  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      preload = [ path ];
      wallpaper = [ ", ${path}" ];
    };
  };
}
