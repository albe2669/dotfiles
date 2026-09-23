{
  category = "System software";
  name = "guiutils";
  software = ["networkmanagerapplet"];

  homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      networkmanagerapplet
    ];
  };
}
