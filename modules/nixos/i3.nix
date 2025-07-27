{
  self,
  pkgs,
  ...
}: {
  imports = [
    self.nixosModules.sddm
  ];

  environment.pathsToLink = ["/libexec"];

  # Possibly move these to ../services
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    libinput.enable = true;

    xserver = {
      enable = true;

      desktopManager = {
        xterm.enable = false;
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          rofi # application launcer
          dunst # notification daemon
          picom # compositor
          redshift # blue light filter
          betterlockscreen # lock screen
          feh # wallpaper
          acpi # battery
          xorg.xbacklight # screen brightness
          xorg.xdpyinfo # screen information
          arandr # screen layout
          sysstat # system information
          nautilus # file manager
        ];
      };

      xkb.layout = "us";
    };
  };
}
