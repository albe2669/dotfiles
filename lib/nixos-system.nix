{inputs, ...}: {
  createNixosConfiguration = machineConfig: system: specialArgs: homeManagerModule:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system specialArgs;

      modules = [
        ../variables.nix
        ../theme.nix

        inputs.disko.nixosModules.disko
        inputs.home-manager.nixosModules.home-manager

        inputs.nixos-generators.nixosModules.all-formats
        {
        }

        {
          # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
          nix.registry.nixpkgs.flake = inputs.nixpkgs;

          # make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
          environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
          nix.nixPath = ["/etc/nix/inputs"];
        }

        machineConfig.nixosModules
        homeManagerModule
      ];
    };
}
