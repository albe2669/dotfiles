{config, ...}: let
  flakeConfig = config;
in {
  flake.modules.nixos.bootloader-uefi = {lib, ...}: {
    imports = [
      flakeConfig.flake.modules.nixos.bootloader
    ];

    boot = {
      loader = {
        efi = {
          canTouchEfiVariables = true;
        };

        grub = {
          device = "nodev";
          devices = ["nodev"];
          efiSupport = true;
          efiInstallAsRemovable = false;
        };
      };
    };
  };

  flake.modules.combined.bootloader-uefi = {...}: {
    imports = [flakeConfig.flake.modules.nixos.bootloader-uefi];
  };
}
