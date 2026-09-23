{config, ...}: {
  category = "System software";
  name = "bootloader-uefi";

  nixos = {...}: {
    imports = [
      config.flake.modules.nixos.bootloader
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
}
