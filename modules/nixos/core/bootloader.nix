{lib, ...}: {
  boot = {
    loader = {
      grub = {
        enable = lib.mkForce true;
        efiSupport = true;
        efiInstallAsRemovable = true;
      };
    };
  };
}
