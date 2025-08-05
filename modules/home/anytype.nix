{
  self,
  system,
  ...
}: {
  home.packages = [
    self.packages.${system}.anytype
  ];
}
