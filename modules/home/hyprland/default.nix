{
  inputs,
  system,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./hypridle.nix
    ./hyprpanel.nix
    ./hyprpaper.nix
    ./hyprlock.nix
    self.homeModules.satty
    ./hyprsunset.nix
  ];

  home.packages = with pkgs; [
    wev
    playerctl
    nwg-displays
    grim
    slurp
    wayfreeze
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
    systemd.variables = ["--all"];
    settings = {
      input = {
        kb_layout = "us,dk";

        accel_profile = "flat";

        touchpad = {
          natural_scroll = true;
        };

        follow_mouse = 1;
        mouse_refocus = false;
      };

      general = {
        layout = "master";
      };

      xwayland = {
        force_zero_scaling = true;
      };

      master = {
        orientation = "center";
      };

      exec-once = [
        "nm-applet"
      ];

      windowrule = [
        "minsize 50% 80%, class:jetbrains-rider"
        "size 20% 40%, class:(jetbrains-)(.*), title:^$, initialTitle:^$, floating:1"
        "center, class:(jetbrains-)(.*), title:^$, initialTitle:^$, floating:1"
        "center, class:(jetbrains-)(.*), initialTitle:(.+), floating:1"
        "noinitialfocus, class:(jetbrains-)(.*), initialTitle:(.+), floating:1"
      ];

      "$mod" = "SUPER";
      "$terminal" = "alacritty";
      "$fileManager" = "nautilus";

      bind =
        [
          "$mod, return, exec, $terminal"
          "$mod SHIFT, q, killactive"
          "$mod, f, fullscreen"
          "$mod SHIFT, space, togglefloating"
          "$mod, escape, exec, hyprlock"

          "$mod SHIFT, r, exec, hyprctl reload"
          "$mod SHIFT, e, exit"

          "$mod CONTROL, u, exec, hyprctl switchxkblayout current 0"
          "$mod CONTROL, d, exec, hyprctl switchxkblayout current 1"

          ",        print, exec, wayfreeze & PID=$!; sleep .1; grim -g \"$(slurp)\" - | wl-copy; kill $PID"
          "SHIFT,   print, exec, grim -g \"$(slurp)\" - | satty -f -"

          "$mod, d,       exec, nc -U /run/user/1000/walker/walker.sock"
          "$mod SHIFT, d, exec, rofi -show p modi p:~/.config/rofi/rofi-power-menu -width 20 -lines 6"

          "$mod, j,     movefocus, d"
          "$mod, k,     movefocus, u"
          "$mod, l,     movefocus, r"
          "$mod, h,     movefocus, l"
          "$mod, down,  movefocus, d"
          "$mod, up,    movefocus, u"
          "$mod, right, movefocus, r"
          "$mod, left,  movefocus, l"

          "$mod SHIFT, j,     movewindow, d"
          "$mod SHIFT, k,     movewindow, u"
          "$mod SHIFT, l,     movewindow, r"
          "$mod SHIFT, h,     movewindow, l"
          "$mod SHIFT, down,  movewindow, d"
          "$mod SHIFT, up,    movewindow, u"
          "$mod SHIFT, right, movewindow, r"
          "$mod SHIFT, left,  movewindow, l"

          "$mod CONTROL, j,     movewindow, mon:d"
          "$mod CONTROL, k,     movewindow, mon:u"
          "$mod CONTROL, l,     movewindow, mon:r"
          "$mod CONTROL, h,     movewindow, mon:l"
          "$mod CONTROL, down,  movewindow, mon:d"
          "$mod CONTROL, up,    movewindow, mon:u"
          "$mod CONTROL, right, movewindow, mon:r"
          "$mod CONTROL, left,  movewindow, mon:l"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (
            builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mod,       code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9
          )
        );
      binde = [
        ", XF86AudioRaiseVolume,  exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute,         exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute,      exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp,   exec, brightnessctl set 10%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioStop, exec, playerctl stop"
      ];
    };
  };
}
