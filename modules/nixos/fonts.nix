{
  self,
  pkgs,
  ...
}: let
  fontConfig = import ./font-packages.nix {inherit pkgs;};
in {
  hm.imports = [
    self.homeModules.fonts
  ];

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;

    packages = fontConfig.packages;
    fontconfig.defaultFonts = fontConfig.defaultFonts;
  };
}
