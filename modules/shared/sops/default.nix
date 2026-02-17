{
  inputs,
  config,
  lib,
  ...
}: let
  username = config.opts.variables.username;

  sharedArgs = {
    defaultSopsFile = ./secrets/secrets.yaml;
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";

    secrets = {
      wakatime_api_key = {
        sopsFile = ./secrets/wakatime.yaml;
      };
      git_credentials = {
        sopsFile = ./secrets/git_credentials.yaml;
      };
      ssh_private_key = {
        sopsFile = ./secrets/ssh.yaml;
        mode = "0600";
      };
      ssh_public_key = {
        sopsFile = ./secrets/ssh.yaml;
        mode = "0644";
      };
    };
  };
in {
  hm.imports = [
    inputs.sops-nix.homeManagerModules.sops
    {
      sops =
        sharedArgs;
    }
  ];

  sops =
    lib.recursiveUpdate
    sharedArgs
    {
      secrets = {
        wakatime_api_key = {
          owner = username;
        };
        git_credentials = {
          owner = username;
        };
        ssh_private_key = {
          owner = username;
        };
        ssh_public_key = {
          owner = username;
        };
      };
    };
}
