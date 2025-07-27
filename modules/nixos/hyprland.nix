{
  pkgs,
  inputs,
  system,
  ...
}: {
  imports = [
    ../services/sddm
  ];

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${system}.hyprland;
      portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;

      xwayland.enable = true;
    };

    hyprlock = {
      enable = true;
    };
  };

  environment.systemPackages = [
    pkgs.kitty # required for the default Hyprland config
  ];

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
}
