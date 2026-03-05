{pkgs-unstable, config, ...}: {
  home.packages = with pkgs-unstable; [
    wtfutil
  ];

  system.environment."WTF_GITHUB_TOKEN" = config.sops.secrets.git_credentials.value;

  xdg.configFile.wtf = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/home/wtf/config");
  };
}
