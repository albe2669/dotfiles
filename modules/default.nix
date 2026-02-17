{
  flake = {
    homeModules = import ./home;
    nixosModules = import ./nixos;
    darwinModules = import ./darwin;
  };
}
