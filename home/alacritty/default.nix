{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    alacritty
  ];

  # TODO: Coloring
  xdg.configFile.alacritty = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
