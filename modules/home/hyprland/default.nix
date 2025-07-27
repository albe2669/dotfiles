{
  inputs,
  system,
  ...
}: {
  # imports = [
  #   ./hidpi.nix
  # ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
    settings = {
      input = {
        kb_layout = "us,dk";

        touchpad = {
          natural_scroll = true;
        };
      };

      "$mod" = "SUPER";
      "$terminal" = "alacritty";
      "$fileManager" = "nautilus";

      bind =
        [
          "$mod, Return, exec, $termnial"
          "$mod SHIFT, q, killactive"
          "$mod, f, fullscreen"
          "$mod SHIFT, space, togglefloating"
          "$mod, escape, exec, hyprlock"

          "$mod SHIFT, r, exec, hyprctl reload"
          "$mod SHIFT, e, exit"

          "$mod CONTROL, u, exec, hyprctl switchxkblayout current 0"
          "$mod CONTROL, d, exec, hyprctl switchxkblayout current 1"

          ",        print, exec, flameshot gui -c -p ~/Pictures/FScreenshots"
          "SHIFT,   print, exec, flameshot screen -c -p ~/Pictures/FScreenshots"
          "CONTROL, print, exec, flameshot screen -p ~/Pictures/FScreenshots"

          "$mod, d,       exec, rofi -show drun"
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
    };
  };
}
