{...}: let
	name = "gosling";
  diskPath = "/dev/nvme0n1";
	disko = import ./disko.nix { diskPath = diskPath; };
in {
	name = name;
	diskPath = diskPath;
	disko = disko;
}
