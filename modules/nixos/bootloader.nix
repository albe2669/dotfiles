{lib, ...}: {
  boot = {
    loader = {
      #systemd-boot = {
      #  enable = lib.mkForce true;
      #};

      efi = {
        canTouchEfiVariables = true;
      };

      grub = {
         enable = true;
         efiSupport = true;
         efiInstallAsRemovable = false;
	       useOSProber = true;
         device = "nodev";
	devices = ["nodev"];
      };
    };
  };
}
