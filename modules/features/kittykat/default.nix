_: {
  flake.modules.homeManager.kittykat = {
    self,
    system,
    config,
    ...
  }: let
    helpers = import ../../../lib/helpers.nix;
  in {
    home.packages = [
      self.packages.${system}.kittykat
    ];

    # Must be installed manually
    xdg.configFile.kittykat = {
      source = helpers.mkDotfilesSymlink config "features/kittykat/config";
    };
  };
}
