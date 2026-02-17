{specialArgs}: {inputs, ...}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    (import ../shared/home.nix {inherit specialArgs;})
  ];
}
