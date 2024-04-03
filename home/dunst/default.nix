{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    dunst
  ];

  xdg.configFile.dunst = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
