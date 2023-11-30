{
  pkgs,
  ...
}: {
	imports = [
		../services/sddm
	];

  environment.pathsToLink = [ "/libexec" ];

  # Possibly move these to ../services
  services = {
    gvfs.enable = true;
    tumbler.enable = true;

    xserver = {
      enable = true;
      libinput.enable = true;

      desktopManager = {
        xterm.enable = false;
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
          gnome.nautilus # file manager
        ];
      };

      layout = "us";
    };
  };
}
