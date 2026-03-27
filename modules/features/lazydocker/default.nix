{ config, ... }: {
  flake.modules.homeManager.lazydocker = {
    pkgs,
    config,
    ...
  }: {
    home.packages = with pkgs; [
      lazydocker
    ];

    xdg.configFile.lazydocker = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/features/lazydocker/config");
    };
  };

  flake.modules.combined.lazydocker = { ... }: {
    hm.imports = [ config.flake.modules.homeManager.lazydocker ];
  };
}
