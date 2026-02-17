{
  config,
  lib,
  ...
}: let
  username = config.opts.variables.username;

  sharedArgs = (import ./args.nix { inherit config; }).sharedArgs;
in {
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
