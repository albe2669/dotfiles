{ pkgs, ... }:
let
  fontConfig = import ../modules/configs/font-packages.nix { inherit pkgs; };
in
{
  home.packages = fontConfig.packages;

  fonts.fontconfig = {
    enable = true;
    defaultFonts = fontConfig.defaultFonts;
  };
}
