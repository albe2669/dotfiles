{
  inputs,
  config,
  ...
}: let
  username = config.opts.variables.username;

  sharedArgs = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";

    secrets = {
      wakatime_api_key = {
      };
      git_credentials = {
      };
      ssh_private_key = {
        mode = "0600";
      };
      ssh_public_key = {
        mode = "0644";
      };
    };
  };
in {
  hm.imports = [
    inputs.sops-nix.homeManagerModules.sops
    {
      sops =
        sharedArgs
        // {
          # defaultSymlinkPath = "/run/user/1000/secrets";
          # defaultSecretsMountPoint = "/run/user/1000/secrets.d";
        };
    }
  ];

  sops =
    sharedArgs
    // {
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
