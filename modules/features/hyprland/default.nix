{
  inputs,
  config,
  ...
}:
let
  flakeConfig = config;
in
{
  flake.modules.nixos.hyprland =
    {
      pkgs,
      system,
      ...
    }:
    {
      imports = [
        flakeConfig.flake.modules.nixos.sddm
      ];

      programs = {
        hyprland = {
          enable = true;
          package = inputs.hyprland.packages.${system}.hyprland;
          portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;

          xwayland.enable = true;
        };
      };

      security.pam.services.hyprlock.text = "auth include login";

      environment.systemPackages = with pkgs; [
        feh
        acpi
        xbacklight
        xdpyinfo
        nautilus
      ];

      nix.settings = {
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };
    };

  flake.modules.homeManager.hyprland =
    {
      inputs,
      system,
      pkgs,
      ...
    }:
    {
      imports = [
        ./hypridle.nix
        ./wayle.nix
        ./hyprpaper.nix
        ./hyprlock.nix
        flakeConfig.flake.modules.homeManager.satty
        ./hyprsunset.nix
      ];

      home.packages = with pkgs; [
        wev
        playerctl
        nwg-displays
        grim
        slurp
        wayfreeze
        brightnessctl
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${system}.hyprland;
        portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
        systemd.variables = [ "--all" ];
        configType = "hyprlang";
        settings = {
          input = {
            kb_layout = "us,dk";

            accel_profile = "flat";

            touchpad = {
              natural_scroll = true;
            };

            follow_mouse = 1;
            mouse_refocus = false;

            repeat_delay = 210;
            repeat_rate = 67;
          };

          general = {
            # layout = "master";
          };

          xwayland = {
            force_zero_scaling = true;
          };

          exec-once = [
            "nm-applet"
          ];

          windowrule = [
            "match:class ^(jetbrains-.*)$, match:title ^(splash)$, match:float true, tag +jetbrains-splash"
            "match:tag jetbrains-splash, center on"
            "match:tag jetbrains-splash, no_focus on"
            "match:tag jetbrains-splash, border_size 0"

            "match:class ^(jetbrains-.*), match:title ^()$, match:float 1, tag +jetbrains"
            "match:tag jetbrains, center on"
            "match:tag jetbrains, stay_focused on"
            "match:tag jetbrains, border_size 0"

            "match:class ^(jetbrains-.*), match:title ^()$, match:float true, size >50% >50%"

            "match:class ^(jetbrains-.*)$, match:title ^(win.*)$, match:float true, no_initial_focus on"

            "match:class ^(jetbrains-.*)$, no_follow_mouse on"

            "match:class ^(Unity)$, match:title ^(UnityTooltipWindow)$, no_initial_focus on"

            "match:class ^(ueberzug.*)$, float on, no_initial_focus on, no_anim on, no_shadow on, no_focus on, border_size 0"
          ];

          "$mod" = "SUPER";
          "$terminal" = "kitty";
          "$fileManager" = "nautilus";

          bind = [
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
          ++ (builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "$mod,       code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            ) 9
          ));
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
    };

  flake.modules.combined.hyprland = { ... }: {
    imports = [ flakeConfig.flake.modules.nixos.hyprland ];
    hm.imports = [ flakeConfig.flake.modules.homeManager.hyprland ];
  };
}
