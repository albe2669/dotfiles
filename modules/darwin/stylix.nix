{
  self,
  inputs,
  ...
}: {
  imports = [
    inputs.stylix.darwinModules.stylix
    self.sharedModules.stylix
  ];
}
