{config, ...}: let
  username = config.opts.variables.username;

  sharedArgs = (import ./args.nix {inherit config;}).sharedArgs;
in {
  sops =
    sharedArgs
    // {
      secrets =
        {
          password = {
            sopsFile = ./secrets/passwd.yaml;
            neededForUsers = true;
          };
          nix_netrc = {
            sopsFile = ./secrets/nix_netrc.yaml;
          };
        }
        // builtins.mapAttrs (key: value: value // {owner = username;}) sharedArgs.secrets;
    };
}
