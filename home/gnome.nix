{
  pkgs,
  theme,
  ...
}:
let
  profileuuid = "e5b5fa5d-4641-4330-ac91-ec61a5fd687b";
in
{
  home.packages = with pkgs; [
    dconf-editor
    gnome-tweaks
  ];

  home.file.".config/pop-shell/config.json" = {
    enable = true;
    text = ''
      {
        "float": [
          {
            "class": "pop-shell-example",
            "title": "pop-shell-example"
          }
        ],
        "skiptaskbarhidden": [],
        "log_on_focus": false
      }
    '';
  };

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = [];
      enabled-extensions = [
        "ding@rastersoft.com"
        "pop-cosmic@system76.com"
        "pop-shell@system76.com"
        "system76-powe r@system76.com"
        "ubuntu-appindicators@ubuntu.com"
        "cosmic-dock@system76.com"
        "cosmic-workspaces@system76.com"
        "popx11gestu res@system76.com"
      ];
    };
    "org/gnome/shell/extensions/pop-shell" = {
      tile-by-default = true;
      snap-to-grid = true;
      gap-inner = 1;
      gap-outer = 1;
      mouse-cursor-follows-active-window = false;
    };
    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };
    "org/gnome/terminal/legacy/profiles:" = {
      default = profileuuid;
      list = [profileuuid];
    };
    "org/gnome/terminal/legacy/profiles:/:${profileuuid}" = {
      visible-name = "Custom profile";
      background-transparency-percent = 3;
      use-theme-transparency = false;
      use-transparent-background = true;
      font = "Iosevka Nerd Font 12";
    };
  };
}
