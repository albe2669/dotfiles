{
  config,
  lib,
  ...
}: let
  username = config.opts.variables.username;

  sharedArgs = (import ./args.nix {inherit config;}).sharedArgs;
in {
  sops =
    sharedArgs
    // {
      secrets = builtins.mapAttrs (key: value: value // {owner = username;}) sharedArgs.secrets;
    };
}
