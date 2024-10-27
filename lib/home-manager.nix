{
  nixpkgs,
  home-manager,
  specialArgs,
  host,
}: let
  username = specialArgs.username;

  sharedConfig = {
    extraSpecialArgs = specialArgs;
  };
in {
  module =
    home-manager.nixosModules.home-manager
    {
      home-manager =
        {
          useGlobalPkgs = true;
          backupFileExtension = "backup";
          useUserPackages = true;

          users."${username}" = {
            imports = [
              host.homeModules
            ];
          };
        }
        // sharedConfig;
    };

  configuration = home-manager.lib.homeManagerConfiguration ({
      pkgs = nixpkgs.legacyPackages.${specialArgs.system};
      modules = [
        host.homeModules
      ];
    }
    // sharedConfig);
}
