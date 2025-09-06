{pkgs, ...}: let
  fontConfig = import ../nixos/font-packages.nix {inherit pkgs;};
in {
  home.packages = fontConfig.packages;

  stylix.targets.fontconfig.enable = true;

  fonts.fontconfig = {
    enable = true;
    defaultFonts = fontConfig.defaultFonts;
  };
}
