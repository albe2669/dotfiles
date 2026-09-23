{config, ...}: {
  category = "Software";
  name = "programs";
  software = [
    "discord"
    "vlc"
    "google-chrome"
  ];

  nixos = _: {
    programs.ssh.startAgent = false;
    programs.dconf.enable = true;
  };

  homeManager = {pkgs, ...}: {
    imports = [
      config.flake.modules.homeManager.yaak
    ];

    home.packages = with pkgs; [
      discord
      vlc
      google-chrome
    ];
  };
}
