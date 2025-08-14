{
  self,
  config,
  inputs,
  ...
}: {
  imports = [
    self.nixosModules.nix
    self.nixosModules.state
    self.nixosModules.libs
    self.nixosModules.dynamic-libs
    self.nixosModules.docker
    self.nixosModules.shell
    self.nixosModules.system-packages
    self.nixosModules.user-groups

    inputs.nixos-wsl.nixosModules.default
    {
      system.stateVersion = config.opts.variables.stateVersion;
      wsl = {
        enable = true;
        defaultUser = config.opts.variables.username;

        docker-desktop.enable = true;
        startMenuLaunchers = true;
      };
    }
  ];

  networking.hostName = config.opts.info.name; # Define your hostname.
}
