{config, ...}: {
  flake.modules.homeManager.dunst = {
    pkgs,
    config,
    ...
  }: {
    home.packages = with pkgs; [
      # dunst
    ];

    xdg.configFile.dunst = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + "/modules/features/dunst/config";
    };
  };

  flake.modules.combined.dunst = _: {
    hm.imports = [config.flake.modules.homeManager.dunst];
  };
}
