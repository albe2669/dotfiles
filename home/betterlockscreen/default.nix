{pkgs, config, ...}: {
  home.packages = with pkgs; [
    feh
    betterlockscreen
  ];
  
  xdg.configFile.betterlockscreen = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
