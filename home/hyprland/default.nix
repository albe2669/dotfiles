{ inputs, system, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "alacritty";
      "$fileManager" = "nautilus";
      bind = [
        "$mod, Return, exec, alacritty"
        "$mod, t, exec, alacritty"
        "$mod SHIFT, Return, exec, alacritty --class floating"
        "$mod SHIFT, q, killactive"
        # "SUPER, l, lock"
      ];
    };
  };
}
