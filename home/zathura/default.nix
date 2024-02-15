{pkgs, config, ...}: {
  home.packages = with pkgs; [
    zathura
  ];

  xdg.configFile.zathura = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
