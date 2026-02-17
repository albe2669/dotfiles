{
  inputs,
  config,
  pkgs,
  ...
}: let
  sharedArgs = (import ../shared/sops/args.nix {inherit config;}).sharedArgs;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  home.packages = with pkgs; [
    sops
    age
  ];

  sops = sharedArgs;
}
