{lib, ...}: {
  imports = [
    ./bootloader.nix
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
}
