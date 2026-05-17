{config, ...}: {
  flake.modules.homeManager.zathura = {
    pkgs,
    lib,
    config,
    ...
  }: {
    home.packages = lib.mkIf pkgs.stdenv.isLinux (with pkgs; [
      zathura
    ]);

    xdg.configFile.zathura = lib.mkIf pkgs.stdenv.isLinux {
      source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/features/zathura/config");
    };
  };

  flake.modules.combined.zathura = {...}: {
    hm.imports = [config.flake.modules.homeManager.zathura];
  };
}
