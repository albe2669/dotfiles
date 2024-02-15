{pkgs, config, ...}: {
  home.packages = with pkgs; [
    lazygit
  ];

  xdg.configFile.lazygit = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
