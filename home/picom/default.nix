{ pkgs, ... }: {
  # I3 currently starts picom for us
  # TODO: Remove this once we have a better way to configure i3
  # services.picom.enable = true;

  home.packages = with pkgs; [
    picom
  ];

  xdg.configFile.picom = {
    source = ./config;
    recursive = true;
  };
}
