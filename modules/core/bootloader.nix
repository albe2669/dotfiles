{
	lib,
	...
}: {
	boot = {
		loader = {
			systemd-boot = {
				configurationLimit = lib.mkDefault 10;
			};

			grub = {
				enable = false;
				device = "/dev/sda"; #  "nodev"
				efiSupport = false;
				useOSProber = true;
			};
		};
	};
}
