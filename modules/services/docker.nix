{
	lib,
	...
}: {
  virtualisation.docker = {
    enable = lib.mkDefault true;
    enableOnBoot = lib.mkDefault true;
  };
}
