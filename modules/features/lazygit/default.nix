{config, ...}: {
  flake.modules.homeManager.lazygit = {
    pkgs,
    config,
    ...
  }: {
    home.packages = with pkgs; [
      lazygit
      # commitizen
    ];

    xdg.configFile.lazygit = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + "/modules/features/lazygit/config";
    };
  };

  flake.modules.combined.lazygit = _: {
    hm.imports = [config.flake.modules.homeManager.lazygit];
  };
}
