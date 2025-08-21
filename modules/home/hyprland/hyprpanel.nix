{ ... }:
let 
  # extraRightModules = if services.tlp.enable then [ "battery" ] else [];
in {
  programs.hyprpanel = {
    enable = true;

    # Configure and theme almost all options from the GUI.
    # See 'https://hyprpanel.com/configuration/settings.html'.
    # Default: <same as gui>
    settings = {

      # Configure bar layouts for monitors.
      # See 'https://hyprpanel.com/configuration/panel.html'.
      # Default: null
      bar = {
        layouts = {
          "*" = {
            left = [ "dashboard" "notifications" "clock" "systray" ];
            middle = [ "media" "workspaces" ];
            right = [ "volume" "microphone" "bluetooth" "network" "ram" "cpu" "cputemp" "storage" "kbinput" ]; # ++ extraRightModules;
          };
        };

        clock = {
          format = "%a %b %d  %H:%M:%S";
        };

        ram = {
          round = true;
        };

        storage = {
          round = true;
        };
      };

      launcher.autoDetectIcon = true;
      workspaces.show_icons = true;

      menus = {
        clock = {
          time = {
            military = true;
            hideSeconds = true;
          };
          weather.unit = "metric";
        };

        dashboard.directories.enabled = false;
        dashboard.stats.enable_gpu = true;
      };

      theme = {
        bar.transparent = true;

        font = {
          name = "CaskaydiaCove NF";
          size = "14px";
        };
      };
    };
  };
}
