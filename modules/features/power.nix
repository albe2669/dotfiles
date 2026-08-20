_: {
  flake.modules.nixos.power = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      powertop
    ];

    powerManagement = {
      enable = true;
      # powertop.enable = true;
    };
  };
}
