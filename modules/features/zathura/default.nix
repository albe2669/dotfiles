{ config, ... }: {
  flake.modules.homeManager.zathura = {
    pkgs,
    config,
    ...
  }: {
    home.packages = with pkgs; [
      zathura
    ];

    xdg.configFile.zathura = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/features/zathura/config");
    };
  };

  flake.modules.combined.zathura = { ... }: {
    hm.imports = [ config.flake.modules.homeManager.zathura ];
  };
}
