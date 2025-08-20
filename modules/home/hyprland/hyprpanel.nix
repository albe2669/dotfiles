{ ... }:
let 
  extraRightModules = if services.tlp.enable then [ "battery" ] else [];
in {
  programs.hyprpanel = {
    # Configure and theme almost all options from the GUI.
    # See 'https://hyprpanel.com/configuration/settings.html'.
    # Default: <same as gui>
    settings = {

      # Configure bar layouts for monitors.
      # See 'https://hyprpanel.com/configuration/panel.html'.
      # Default: null
      layout = {
        bar = {
          layouts = {
            "*" = {
              left = [ "dashboard" "clock" "systray" ];
              middle = [ "media" "workspaces" ];
              right = [ "volume" "microphone" "bluetooth" "network" "ram" "cpu" "cputemp" "storage" "kbinput" "hyprsunset" "hypridle" "notifications" "power" ] ++ extraRightModules;
            };
          };
        };

        launcher.autoDetectIcon = true;
        workspaces.show_icons = true;
      };

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
          size = "16px";
        };
      };
    };
  };
}
