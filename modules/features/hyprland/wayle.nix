{
  config,
  ...
}:
let
  inherit (config.stylix) fonts;
in
{
  services.wayle = {
    enable = true;

    settings = {
      bar = {
        bg = "transparent";
        button-gap = 1.15;
        button-label-padding = 1.05;
        button-rounding = "lg";
        button-variant = "basic";
        layout = [
          {
            center = [
              "media"
              "hyprland-workspaces"
            ];
            left = [
              "dashboard"
              "hyprsunset"
              "notifications"
              "clock"
              "systray"
            ];
            monitor = "*";
            right = [
              "volume"
              "microphone"
              "ram"
              "cpu"
              "storage"
              "keyboard-input"
              "network"
              "bluetooth"
            ];
            show = true;
          }
        ];
        padding = 0.5;
        padding-ends = 1.28;
      };
      general = {
        font-mono = fonts.monospace.name;
        font-sans = fonts.sansSerif.name;
      };
      modules = {
        keyboard-input = {
          layout-alias-map = {
            Danish = "DK";
            "English (US)" = "EN";
          };
        };
        clock = {
          dropdown-show-seconds = true;
          format = "%a %b %d %H:%M";
        };
        weather = {
          location = "Copenhagen";
          time-format = "24h";
        };
      };
      styling = {
        palette = {
          bg = "#2d353b";
          blue = "#83c092";
          elevated = "#3d484d";
          fg = "#d3c6aa";
          fg-muted = "#859289";
          green = "#a7c080";
          primary = "#7fbbb3";
          red = "#e67e80";
          surface = "#343f44";
          yellow = "#dbbc7f";
        };
      };
    };
  };
}
