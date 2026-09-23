{
  category = "System software";
  name = "sops";
  software = ["sops" "age"];

  nixos = {
    config,
    inputs,
    ...
  }: let
    username = config.opts.variables.username;
    inherit ((import ./args.nix {inherit config;})) sharedArgs;
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
          // builtins.mapAttrs (_key: value: value // {owner = username;}) sharedArgs.secrets;
      };
  };

  darwin = {
    config,
    inputs,
    ...
  }: let
    username = config.opts.variables.username;
    inherit ((import ./args.nix {inherit config;})) sharedArgs;
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
          // builtins.mapAttrs (_key: value: value // {owner = username;}) sharedArgs.secrets;
      };
  };

  homeManager = {
    config,
    pkgs,
    ...
  }: let
    inherit ((import ./args.nix {inherit config;})) sharedArgs;
  in {
    home.packages = with pkgs; [
      sops
      age
    ];

    sops = sharedArgs;
  };
}
