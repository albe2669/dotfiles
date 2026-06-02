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
      source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/features/opencode/config");
    };
  };

  flake.modules.combined.opencode = {...}: {
    hm.imports = [config.flake.modules.homeManager.opencode];
  };
}
