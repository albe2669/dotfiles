_: {
  flake.modules.homeManager.guiutils = {pkgs, ...}: {
    home.packages = with pkgs; [
      # Networks
      networkmanagerapplet
    ];
  };
}
