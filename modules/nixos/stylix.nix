{
  self,
  inputs,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
    self.sharedModules.stylix
  ];
}
