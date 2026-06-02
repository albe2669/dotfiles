{config, ...}: {
  flake.modules.homeManager.sioyek = {
    pkgs,
    config,
    ...
  }: {
    home.packages = with pkgs; [
      sioyek
    ];

    xdg.configFile.sioyek = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/features/sioyek/config");
    };
  };

  flake.modules.combined.sioyek = {...}: {
    hm.imports = [config.flake.modules.homeManager.sioyek];
  };
}
