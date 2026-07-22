{config, ...}: {
  flake.modules.homeManager.wtf = {
    pkgs-unstable,
    pkgs,
    config,
    lib,
    ...
  }: {
    home.packages = with pkgs-unstable; [
      wtfutil
    ];

    programs.fish.shellInit = ''
      set -x WTF_GITHUB_TOKEN (${lib.getExe pkgs.gh} auth token)
    '';

    xdg.configFile.wtf = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + "/modules/features/wtf/config";
    };
  };

  flake.modules.combined.wtf = _: {
    hm.imports = [config.flake.modules.homeManager.wtf];
  };
}
