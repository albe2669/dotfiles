{
  pkgs,
  ...
}: {
  environment.pathsToLink = [ "/libexec" ];

  # Possibly move these to ../services
  services = {
    gvfs.enable = true;
    tumbler.enable = true;

    xserver = {
      enable = true;

      desktopManager = {
        xterm.enable = false;
      }

      displayManager = {
        defaultSession = "none+i3";
        sddm.enable = false;
        lightdm.enable = false;
        gdm.enable = false;
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          rofi # application launcer
          dunst # notification daemon
          picom # compositor
          xclip # clipboard manager
          redshift # blue light filter
          betterlockscreen # lock screen
          feh # wallpaper
          flameshot # screenshot
          acpi # battery
          xorg.xbacklight # screen brightness
          xorg.xdpyinfo # screen information
          arandr # screen layout
          sysstat # system information
          nautilus # file manager
        ];
      };

      layout = "us";
    };
  };
}
