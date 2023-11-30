{
	pkgs,
	...
}: {
	services = {
		xserver = {
			enable = true;
      displayManager = {
        lightdm.enable = false;
        gdm.enable = false;
				
				sddm = {
					enable = true;
					enableHidpi = true;
					theme = "sddm-sugar-candy";
				};
      };
		};
	};

	environment.systemPackages = with pkgs; [
		(libsForQt5.callPackage ./themes/sugar-candy {})
	];
}
