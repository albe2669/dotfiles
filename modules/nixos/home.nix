{
  self,
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager

    {
      home-manager = {
        useGlobalPkgs = true;
        backupFileExtension = "backup";
        useUserPackages = true;

        extraSpecialArgs = {
          inherit inputs self;
        };

        users."${config.opts.variables.username}" = {
          imports = [
            ../../variables.nix
            ../../theme.nix
          ];
        };
      };
    }

    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" config.opts.variables.username])
  ];
}
