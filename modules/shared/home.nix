{specialArgs}: {
  self,
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    {
      home-manager = {
        useGlobalPkgs = true;
        backupFileExtension = "backup";
        useUserPackages = true;

        extraSpecialArgs = specialArgs;

        users."${config.opts.variables.username}" = {
          imports = [
            ../../variables.nix
            ../../theme.nix
            inputs.sops-nix.homeManagerModules.sops
            self.homeModules.sops
          ];
        };
      };
    }

    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" config.opts.variables.username])
  ];
}
