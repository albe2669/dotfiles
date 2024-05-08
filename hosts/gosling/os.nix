{...}: let
  info = import ./info.nix {};
in {
  imports = [
    (import ../../modules/core-desktop.nix {diskPath = info.diskPath;})
    ../../modules/core-laptop.nix
    ../../modules/core/nvidia.nix
    ../../modules/configs/hidpi.nix
    ../../modules/services/bluetooth.nix
    ../../modules/services/wireless.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    info.disko
  ];

  networking.hostName = info.name; # Define your hostname.
}
