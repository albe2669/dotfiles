{config, ...}: {
  flake.modules.homeManager.wallpapers = {config, ...}: {
    xdg.configFile.wallpapers = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + "/modules/features/wallpapers/images";
    };
  };

  flake.modules.combined.wallpapers = _: {
    hm.imports = [config.flake.modules.homeManager.wallpapers];
  };
}
