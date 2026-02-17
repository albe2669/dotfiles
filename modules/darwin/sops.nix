{
  self,
  inputs,
  ...
}: {
  imports = [
    self.sharedModules.sops
    inputs.sops-nix.darwinModules.sops
  ];
}
