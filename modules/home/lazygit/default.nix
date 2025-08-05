{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    lazygit
    commitizen
  ];

  xdg.configFile.lazygit = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/home/lazygit/config");
  };
}
