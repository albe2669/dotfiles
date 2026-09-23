{
  category = "System software";
  name = "bluetooth";
  software = ["bluetuith"];

  nixos = _: {
    hardware.bluetooth.enable = true;
    services.blueman.enable = false;
  };

  homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      bluetuith
    ];
  };
}
