{
  ...
}: {
  imports = [
    ../../modules/core-desktop.nix
    # Probably does nothing as it's a vm, but it tests if the installation is successful.
    ../../modules/core-laptop.nix
    ../../modules/services/bluetooth.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking.hostName = "skein"; # Define your hostname.
}
