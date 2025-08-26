{
  self,
  config,
  inputs,
  ...
}: {
  imports = [
    self.nixosModules.core-desktop
    self.nixosModules.core-laptop
    self.nixosModules.bootloader-uefi
    self.nixosModules.dynamic-libs
    self.nixosModules.touchpad
    self.nixosModules.hidpi
    self.nixosModules.bluetooth
    self.nixosModules.wireless

    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-12th-gen
  ];

  networking.hostName = config.opts.info.name; # Define your hostname.
}
