{config, ...}: {
  flake.modules.homeManager.opencode = {
    pkgs-unstable,
    config,
    ...
  }: {
    home.packages = with pkgs-unstable; [
      opencode
    ];

    xdg.configFile.opencode = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + "/modules/features/opencode/config";
    };
  };

  flake.modules.combined.opencode = _: {
    hm.imports = [config.flake.modules.homeManager.opencode];
  };
}
