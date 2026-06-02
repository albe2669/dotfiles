{...}: {
  stylix.targets.hyprpaper.enable = true;

  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
    };
  };
}
