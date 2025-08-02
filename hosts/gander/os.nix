{
  self,
  inputs,
  config,
  ...
}: {
  imports = [
    self.nixosModules.core-desktop
    self.nixosModules.nvidia
    self.nixosModules.dynamic-libs
    self.nixosModules.qemu

	  # nixos-hardware
		# nixos-hardware/tree/master/common/gpu/nvidia/pascal
		# nixos-hardware/blob/master/common/cpu/intel/skylake
  ];

  networking.hostName = config.opts.info.name; # Define your hostname.
}
