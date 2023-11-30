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
      libinput.enable = true;

      desktopManager = {
        default = "none";
        xterm.enable = false;
      };

      displayManager = {
        sddm.enable = true;
        lightdm.enable = false;
        gdm.enable = false;
      };

      windowManager.default = "i3";
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          i3blocks
          i3status

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
          gnome.nautilus # file manager
        ];
      };

      layout = "us";
    };
  };
}
