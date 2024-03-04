{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/core-desktop.nix
    ../../modules/services/bluetooth.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking.hostName = "skein"; # Define your hostname.
}
