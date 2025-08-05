{
  self,
  lib,
  ...
}: {
  imports = [
    # Core
    self.nixosModules.nix
    self.nixosModules.state
    self.nixosModules.network
    self.nixosModules.libs

    # Services
    self.nixosModules.docker
    self.nixosModules.power

    # Configs
    self.nixosModules.system-packages
    self.nixosModules.user-groups
  ];

  time.timeZone = "Europe/Copenhagen";

  i18n.defaultLocale = "en_US.UTF-8";

  services.openssh = {
    enable = lib.mkDefault true;
    settings = {
      X11Forwarding = lib.mkDefault true;
      PermitRootLogin = lib.mkDefault "no";
      PasswordAuthentication = lib.mkDefault false;
    };
    openFirewall = lib.mkDefault true;
  };
}
