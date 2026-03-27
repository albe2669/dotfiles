{ config, ... }: {
  flake.modules.homeManager.wallpapers = {config, ...}: {
    xdg.configFile.wallpapers = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/features/wallpapers/images");
    };
  };

  flake.modules.combined.wallpapers = { ... }: {
    hm.imports = [ config.flake.modules.homeManager.wallpapers ];
  };
}
