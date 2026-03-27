{config, ...}: let
  flakeConfig = config;
in {
  flake.modules.nixos.programs = {...}: {
    programs.ssh.startAgent = false; # Disabled due to conflict with services.gnome.gcr-ssh-agent
    programs.dconf.enable = true;
  };

  flake.modules.homeManager.programs = {pkgs, ...}: {
    imports = [
      flakeConfig.flake.modules.homeManager.yaak
    ];

    home.packages = with pkgs; [
      discord
      vlc
      google-chrome
    ];
  };

  flake.modules.combined.programs = {...}: {
    imports = [config.flake.modules.nixos.programs];
    hm.imports = [config.flake.modules.homeManager.programs];
  };
}
