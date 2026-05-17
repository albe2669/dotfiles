{config, ...}: {
  flake.modules.homeManager.lazygit = {
    pkgs,
    config,
    ...
  }: {
    home.packages = with pkgs; [
      lazygit
      commitizen
    ];

    xdg.configFile.lazygit = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/features/lazygit/config");
    };
  };

  flake.modules.combined.lazygit = {...}: {
    hm.imports = [config.flake.modules.homeManager.lazygit];
  };
}
