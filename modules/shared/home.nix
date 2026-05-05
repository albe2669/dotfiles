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

          opts.variables.isDarwin = config.opts.variables.isDarwin;
        };
      };
    }

    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" config.opts.variables.username])
  ];
}
