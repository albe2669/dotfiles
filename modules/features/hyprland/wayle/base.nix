{
  bar = {
    button-bg-opacity = 0;
    button-gap = 1.15;
    button-icon-size = 0.8;
    button-label-padding = 1.05;
    button-label-weight = "normal";
    layout = [
      {
        center = [ "media" ];
        left = [
          "dashboard"
          "hyprland-workspaces"
          "hyprsunset"
          "systray"
        ];
        monitor = "*";
        right = [
          {
            module = "cpu";
            class = "goose-cpu";
          }
          "ram"
          "storage"
          "volume"
          "microphone"
          "separator"
          "keyboard-input"
          "network"
          "blue
tooth"
          "separator"
          "notifications"
          "clock"
        ];
        show = true;
      }
    ];
    padding = 0;
    padding-ends = 0;
  };
  general = {
    font-mono = "Iosevka Nerd Font Mono";
    font-sans = "Iosevka Nerd Fon
t";
  };
  modules = {
    clock = {
      dropdown-show-seconds = true;
      format = "%a %b %d %H:%M";
    };
    cpu = {
      border-color = "#7fbbb3";
      format = "CPU {{ percent }}%";
      icon-bg-color = "#7fbbb
3";
      icon-color = "accent";
      icon-name = "tbf-circle-symbolic";
      label-color = "fg-default";
    };
    keyboard-input = {
      layout-alias-map = {
        Danish = "DK";
        "English (US)" = "EN";
      };
    };
    separator = {
      color = "status-error";
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
      elevated = "#3
d484d";
      fg = "#d3c6aa";
      fg-muted = "#859289";
      green = "#a7c080";
      primary = "#7fbbb3";
      red = "#e67e80";
      surface = "#343f44";
      yellow = "#dbbc7f";
    };
  };
}
