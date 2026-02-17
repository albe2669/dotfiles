{
  self,
  inputs,
  ...
}: {
  imports = [
    self.sharedModules.sops
    inputs.sops-nix.nixosModules.sops
  ];
}
