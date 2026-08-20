_: {
  flake.modules.nixos.bluetooth = _: {
    hardware.bluetooth.enable = true;
    services.blueman.enable = false;
  };

  flake.modules.homeManager.bluetooth = {pkgs, ...}: {
    home.packages = with pkgs; [
      bluetuith
    ];
  };
}
