{
  pkgs,
  variables,
  lib,
  ...
}:
let
  profileuuid = "e5b5fa5d-4641-4330-ac91-ec61a5fd687b";
  backgroundSettings = {
    color-shading-type = "solid";
    picture-options = "zoom";
    picture-uri-dark = "file://${variables.homeDirectory.path}/.background-image";
    # picture-uri-dark = "file:///home/goose/.local/share/backgrounds/2025-03-17-19-02-54-demon_goose.png";
    primary-color = "#000000000000";
    secondary-color = "#000000000000";
  };

  flameshotDir = variables.homeDirectory.path + (builtins.toPath "/Pictures/FScreenshots");
in
with lib.hm.gvariant; {
  imports = [
    ../home/wallpapers/default.nix
  ];

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
    "org/gnome/desktop/input-sources" = {
      sources = [
        (mkTuple [ "xkb" "us" ])
        (mkTuple [ "xkb" "dk+winkeys" ])
      ];
    };
    "org/gnome/desktop/screensaver" = backgroundSettings;
    "org/gnome/desktop/background" = backgroundSettings;
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

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/PopLaunch1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "Print";
      name = "Flameshot - gui";
      command = "flameshot gui -c -p ${flameshotDir}";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Primary>Print";
      name = "Flameshot - screen";
      command = "flameshot screen -p ${flameshotDir}";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Shift>Print";
      name = "Flameshot - screen copy";
      command = "flameshot screen -c -p ${flameshotDir}";
    };

    "org/gnome/shell/keybindings/show-screenshot-ui" = {
      binding = "";
    };
    "org/gnome/shell/keybindings/screenshot" = {
      binding = "";
    };
  };
}
