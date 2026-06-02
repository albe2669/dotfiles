{
  pkgs,
  self,
  ...
}: {
  imports = [
    self.homeModules.yaak
  ];

  home.packages = with pkgs; [
    discord
    vlc
    google-chrome
  ];
}
