{
  self,
  config,
  ...
}: {
  imports = [
    ./info.nix

    self.nixosModules.core-server

    # Probably does nothing as it's a vm, but it tests if the installation is successful.
    # ../../modules/core-laptop.nix
    # ../../modules/services/bluetooth.nix
    #
    # # Include the results of the hardware scan.
    # ./hardware-configuration.nix
    #
    # ../../modules/configs/hyprland.nix
  ];

  networking.hostName = config.opts.info.name; # Define your hostname.
}
