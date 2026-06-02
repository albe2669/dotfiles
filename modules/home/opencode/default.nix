{
  pkgs-unstable,
  config,
  ...
}: {
  home.packages = with pkgs-unstable; [
    opencode
  ];

  xdg.configFile.opencode = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/home/opencode/config");
  };
}
