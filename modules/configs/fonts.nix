{pkgs, ...}:
let
  fontConfig = import ./font-packages.nix { inherit pkgs; };
in
{
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;

    packages = fontConfig.packages;
    fontconfig.defaultFonts = fontConfig.defaultFonts;
  };
}
