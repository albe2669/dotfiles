{
  inputs,
  self,
  config,
  ...
}: {
  flake.modules.nixos.home-manager-wiring = {
    config,
    lib,
    pkgs,
    ...
  }: let
    pkgs-unstable = import inputs.nixpkgs-unstable {
      system = pkgs.system;
      config.allowUnfree = true;
      config.permittedInsecurePackages = [
        "electron-29.4.6"
      ];
      overlays = import ../overlays {inherit inputs;};
    };
  in {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" config.opts.variables.username])
    ];

    _module.args = {
      inherit pkgs-unstable;
      username = config.opts.variables.username;
    };

    home-manager = {
      useGlobalPkgs = true;
      backupFileExtension = "backup";
      useUserPackages = true;

      extraSpecialArgs = {
        inherit inputs self pkgs-unstable;
        system = pkgs.system;
        username = config.opts.variables.username;
      };

      users."${config.opts.variables.username}" = {
        imports = [
          ../variables.nix
          ../theme.nix
          inputs.sops-nix.homeManagerModules.sops
        ];

        opts.variables.isDarwin = config.opts.variables.isDarwin;
      };
    };
  };

  flake.modules.darwin.home-manager-wiring = {
    config,
    lib,
    pkgs,
    ...
  }: let
    pkgs-unstable = import inputs.nixpkgs-unstable {
      system = pkgs.system;
      config.allowUnfree = true;
      config.permittedInsecurePackages = [
        "electron-29.4.6"
      ];
      overlays = import ../overlays {inherit inputs;};
    };
  in {
    imports = [
      inputs.home-manager.darwinModules.home-manager
      (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" config.opts.variables.username])
    ];

    _module.args = {
      inherit pkgs-unstable;
      username = config.opts.variables.username;
    };

    home-manager = {
      backupFileExtension = "backup";
      useUserPackages = true;

      sharedModules = [
        {_module.args.pkgs = lib.mkForce pkgs-unstable;}
      ];

      extraSpecialArgs = {
        inherit inputs self pkgs-unstable;
        system = pkgs.system;
        username = config.opts.variables.username;
      };

      users."${config.opts.variables.username}" = {
        imports = [
          ../variables.nix
          ../theme.nix
          inputs.sops-nix.homeManagerModules.sops
        ];

        opts.variables.isDarwin = config.opts.variables.isDarwin;
      };
    };
  };
}
