{
  flake = {
    homeModules = import ./home;
    nixosModules = import ./nixos;
  };
}
