{
  self,
  inputs,
  config,
  ...
}: let
  createNixosConfiguration = (import ../lib/nixos-system.nix { inherit inputs; }).createNixosConfiguration;
  createHomeConfiguration = (import ../lib/home-manager.nix { inherit self inputs; }).createHomeConfiguration;

  system = "x86_64-linux";

  specialArgs = rec {
    inherit self inputs system;

    username = config.variables.username;

    pkgs-unstable = import inputs.nixpkgs-unstable {
      system = system;

      # Necessary for installing paid or non-free software
      config.allowUnfree = true;

      config.permittedInsecurePackages = [
        "electron-29.4.6"
      ];

      # Overlays are only applied to the unstable channel, since they probably are
      overlays = import ../overlays {};
    };
  };

  allHosts = [
    "gander"
    "gosling"
    "skein"
    "larry"
  ];

  allConfigurations =
    builtins.listToAttrs (builtins.map (host: 
      let 
        hostConf = import ./${host} {};
      in {
        name = host;
        value = rec {
          inherit (hostConf) info nixosModules homeModules;
          name = host;
          homeManagerConfiguration = createHomeConfiguration hostConf system specialArgs;
          nixosConfiguration = if (builtins.hasAttr "nixosModules" hostConf) then
            createNixosConfiguration hostConf system specialArgs homeManagerConfiguration.module
          else
            null;
        };
    }) allHosts);


  nixosConfigurations = builtins.mapAttrs (_: hostConf:
    if (builtins.hasAttr "nixosConfiguration" hostConf) then
      hostConf.nixosConfiguration
    else
      null
  ) allConfigurations;
in {
  flake.nixosConfigurations = nixosConfigurations;

  flake.homeConfigurations =
    builtins.mapAttrs (
      _: hostConf:
        hostConf.homeManagerConfiguration.configuration
    )
    allConfigurations;

  flake.packages."${system}" =
    builtins.mapAttrs (
      _: hostConf:
        hostConf.nixosConfiguration.config.formats
    )
    allConfigurations;

  flake.hosts = allConfigurations;
}
