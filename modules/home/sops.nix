{
  inputs,
  config,
  ...
}: let 
  sharedArgs = (import ../shared/sops/args.nix { inherit config; }).sharedArgs;
in{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = sharedArgs;
}
