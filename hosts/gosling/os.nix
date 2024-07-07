{...}: let
  info = import ./info.nix {};
in {
  imports = [
    (import ../../modules/core-desktop.nix {diskPath = info.diskPath;})
    ../../modules/core-laptop.nix
    ../../modules/core/nvidia.nix
    ../../modules/core/nvidia-prime.nix
    ../../modules/configs/touchpad.nix
    ../../modules/configs/hidpi.nix
    ../../modules/services/bluetooth.nix
    ../../modules/services/wireless.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    info.disko
  ];

  networking.hostName = info.name; # Define your hostname.

  hardware.nvidia.prime = {
    # Make sure to use the correct Bus ID values for your system!
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}
