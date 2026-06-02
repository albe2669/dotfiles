let
  info = import ./info.nix;
in {
  imports = [
    ./os.nix
    ./home.nix
    ./hardware-configuration.nix
    (import ./disko.nix {diskPath = info.diskPath;})
  ];
}
