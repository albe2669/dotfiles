{
  inputs,
  config,
  ...
}: let
  flakeConfig = config;
in {
  flake.modules.nixos.sops = {config, ...}: let
    username = config.opts.variables.username;
    sharedArgs = (import ./args.nix {inherit config;}).sharedArgs;
  in {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];

    sops =
      sharedArgs
      // {
        secrets =
          {
            password = {
              sopsFile = ./secrets/passwd.yaml;
              neededForUsers = true;
            };
          }
          // {
            nix_netrc = {
              sopsFile = ./secrets/nix_netrc.yaml;
            };
          }
          // builtins.mapAttrs (key: value: value // {owner = username;}) sharedArgs.secrets;
      };
  };

  flake.modules.darwin.sops = {config, ...}: let
    username = config.opts.variables.username;
    sharedArgs = (import ./args.nix {inherit config;}).sharedArgs;
  in {
    imports = [
      inputs.sops-nix.darwinModules.sops
    ];

    sops =
      sharedArgs
      // {
        secrets =
          {
            password = {
              sopsFile = ./secrets/passwd.yaml;
              neededForUsers = true;
            };
          }
          // {
            nix_netrc = {
              sopsFile = ./secrets/nix_netrc.yaml;
            };
          }
          // builtins.mapAttrs (key: value: value // {owner = username;}) sharedArgs.secrets;
      };
  };

  flake.modules.homeManager.sops = {
    config,
    pkgs,
    ...
  }: let
    sharedArgs = (import ./args.nix {inherit config;}).sharedArgs;
  in {
    home.packages = with pkgs; [
      sops
      age
    ];

    sops = sharedArgs;
  };

  flake.modules.combined.sops = {system, ...}: let
    isDarwin = builtins.match ".*-darwin" system != null;
  in {
    imports = [
      (
        if isDarwin
        then flakeConfig.flake.modules.darwin.sops
        else flakeConfig.flake.modules.nixos.sops
      )
    ];
    hm.imports = [flakeConfig.flake.modules.homeManager.sops];
  };
}
