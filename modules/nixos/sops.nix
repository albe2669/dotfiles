{
  self,
  inputs,
  config,
  ...
}: let
  username = config.opts.variables.username;
in {
  imports = [
    self.sharedModules.sops
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    secrets = {
      ssh_private_key = {
        path = "/home/${username}/.ssh/id_ed25519";
      };
    };
  };
}
