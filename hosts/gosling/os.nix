{
  self,
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [
    self.nixosModules.core-desktop
    self.nixosModules.core-laptop
    self.nixosModules.bootloader-uefi
    self.nixosModules.nvidia
    self.nixosModules.nvidia-prime
    self.nixosModules.dynamic-libs
    self.nixosModules.touchpad
    self.nixosModules.hidpi
    self.nixosModules.bluetooth
    self.nixosModules.qemu
    # self.nixosModules.tailscale
    self.nixosModules.wireless

    inputs.nixos-hardware.nixosModules.dell-xps-15-9520-nvidia
  ];

  opts.variables.isHidpi = lib.mkForce true;
  hm.imports = [
    {
      opts.variables.isHidpi = lib.mkForce true;
    }
  ];

  networking.hostName = config.opts.info.name; # Define your hostname.
}
