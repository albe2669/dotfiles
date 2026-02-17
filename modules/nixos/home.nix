{specialArgs}: {inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    (import ../shared/home.nix {inherit specialArgs;})
  ];
}
