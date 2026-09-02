_: {
  flake.modules.nixos.power = {
    pkgs,
    lib,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      powertop
    ];

    powerManagement = {
      enable = lib.mkDefault true;
      # powertop.enable = true;
    };
  };
}
