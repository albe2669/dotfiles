_: {
  flake.modules.homeManager.rune = {
    self,
    system,
    ...
  }: {
    home.packages = [
      self.packages.${system}.rune
    ];

    xdg.configFile.rune = {
      source = helpers.mkDotfilesSymlink config "features/rune/config";
    };
  };
}
