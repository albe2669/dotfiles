{...}: let
  diskPath = "/dev/nvme0n1";
in {
  imports = [
    ../../modules/core-desktop.nix
    ../../modules/core-laptop.nix
    ../../modules/core/nvidia.nix
    ../../modules/configs/hidpi.nix
    ../../modules/services/bluetooth.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    (import ./disko.nix { diskPath = diskPath; })
  ];

  networking.hostName = "gosling"; # Define your hostname.
}
