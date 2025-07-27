{
  self,
  config,
  ...
}: {
  imports = [
    ./info.nix

    self.nixosModules.core-desktop

    # Probably does nothing as it's a vm, but it tests if the installation is successful.
    self.nixosModules.core-laptop
    self.nixosModules.bluetooth

    # # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking.hostName = config.opts.info.name; # Define your hostname.
}
