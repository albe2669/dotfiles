{...}: let
  diskPath = "/dev/sda";
in {
  imports = [
    (import ../../modules/core-desktop.nix {diskPath = diskPath; })
    # Probably does nothing as it's a vm, but it tests if the installation is successful.
    ../../modules/core-laptop.nix
    ../../modules/services/bluetooth.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    (import ./disko.nix { diskPath = diskPath; })
  ];

  networking.hostName = "skein"; # Define your hostname.
}
