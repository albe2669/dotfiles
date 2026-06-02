{
  self,
  inputs,
  config,
  ...
}: {
  imports = [
    self.nixosModules.core-desktop
    self.nixosModules.amd
    self.nixosModules.dynamic-libs
    self.nixosModules.qemu
    self.nixosModules.bootloader-uefi

    # nixos-hardware
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
  ];

  networking.hostName = config.opts.info.name; # Define your hostname.
}
