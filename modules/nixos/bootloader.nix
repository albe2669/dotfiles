{lib, ...}: {
  boot = {
    loader = {
			systemd-boot = {
				enable = lib.mkForce true;
			};

			efi = {
				canTouchEfiVariables = true;
			};

      grub = {
        enable = lib.mkForce true;
        efiSupport = true;
        efiInstallAsRemovable = true;
      };
    };
  };
}
