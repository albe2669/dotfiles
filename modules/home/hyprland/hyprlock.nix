{
  config,
  lib,
  ...
}: let
  inherit (config.lib.stylix) colors;
  inherit (config.stylix.fonts) monospace;
in {
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = false;
        grace = 0;
      };

      background = {
        path="screenshot";
        blur_passes = 2;
        contrast = 0.9;
        brightness = 0.5;
        vibrancy = 0.17;
        vibrancy_darkness = 0;
      };

      input-field = [
        {
          size = "300, 40";
          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          fade_on_empty = false;
          font_family = monospace.name;
          hide_input = false;
          position = "0, -200";
          halign = "center";
          valign = "center";

          # outer_color = "rgba (0, 0, 0, 0)";
          # outer_color = "rgb(${base03})";
          inner_color = "rgb(${colors.base00})";
          font_color = "rgb(${colors.base05})";
          fail_color = "rgb(${colors.base08})";
          check_color = "rgb(${colors.base0A})";

        }
      ];

      label = [
        # Hour-Time
        {
          text = ''cmd[update:1000] echo -e "$(date +"%H")"'';
          color = "0x80${colors.base0F}";
          font_family = monospace.name;
          font_size = "140";
          position = "0, 300";
          halign = "center";
          valign = "center";
        }

        # Minute-Time
        {
          text = ''cmd[update:1000] echo -e "$(date +"%M")"'';
          color = "rgba(255, 255, 255, 1)";
          font_size = "140";
          position = "0, 75";
          halign = "center";
          valign = "center";
        }

        # Day-Date-Month
        {
          text = ''cmd[update:1000] echo "<span color='##ffffff00'>$(date '+%A, ')</span><span color='##928cff00'>$(date '+%d %B')</span>"'';
          font_size = "30";
          font_family = monospace.name;
          position = "0, 80";
          halign = "center";
          valign = "bottom";
        }
      ];
    };
  };
}
