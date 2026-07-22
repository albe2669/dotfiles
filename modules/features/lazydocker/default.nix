{config, ...}: {
  flake.modules.homeManager.lazydocker = {
    pkgs,
    config,
    ...
  }: {
    home.packages = with pkgs; [
      lazydocker
    ];

    xdg.configFile.lazydocker = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + "/modules/features/lazydocker/config";
    };
  };

  flake.modules.combined.lazydocker = _: {
    hm.imports = [config.flake.modules.homeManager.lazydocker];
  };
}
