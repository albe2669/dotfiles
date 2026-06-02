{specialArgs}: {
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    (import ../shared/home.nix {inherit specialArgs;})
  ];

  home-manager.sharedModules = [
    {_module.args.pkgs = lib.mkForce specialArgs.pkgs-unstable;}
  ];
}
