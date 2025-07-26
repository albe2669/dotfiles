{
  self,
  inputs,
  ...
}: 
{
  createHomeConfiguration =
    machineConfig: system: specialArgs:
    let 
      sharedImports = [
        ../variables.nix
        ../theme.nix

        machineConfig.homeModules
      ];
    in {
      configuration = inputs.home-manager.lib.homeManagerConfiguration ({
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        extraSpecialArgs = specialArgs;

        modules = [
          # self.nixosModules.core.nix
        ] ++ sharedImports;
      });

      module = {
        home-manager = {
          useGlobalPkgs = true;
          backupFileExtension = "backup";
          useUserPackages = true;

          extraSpecialArgs = specialArgs;

          users."${specialArgs.username}" = {
            imports = [
            ] ++ sharedImports;
          };
        };
      };
    };
}
