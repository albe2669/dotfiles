{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    polybar
  ];

  xdg.configFile.polybar = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
