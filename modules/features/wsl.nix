{inputs, ...}: {
  category = "System software";
  name = "wsl";

  nixos = {
    config,
    inputs,
    lib,
    ...
  }: {
    imports = [
      inputs.nixos-wsl.nixosModules.default
      {
        system.stateVersion = config.opts.variables.stateVersion;
        wsl.enable = true;
        wsl.defaultUser = config.opts.variables.username;
      }
    ];

    networking.wireless.enable = lib.mkForce false;
  };
}
