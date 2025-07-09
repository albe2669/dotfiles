{
  inputs,
  variables,
  ...
}: let
  info = import ./info.nix {};
in {
  imports = [
    ../../modules/core/nix.nix
    ../../modules/core/state.nix
    ../../modules/core/libs.nix

    ../../modules/services/docker.nix
    ../../modules/services/shell.nix

    ../../modules/configs/system-packages.nix
    ../../modules/configs/user-groups.nix

    inputs.nixos-wsl.nixosModules.default
    {
      system.stateVersion = variables.stateVersion;
      wsl = {
        enable = true;
        defaultUser = variables.username;
      };
    }
  ];

  networking.hostName = info.name; # Define your hostname.
}
