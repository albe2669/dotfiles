{lib, ...}: {
  imports = [
    # Core
    # ./core/nix.nix
    # ./core/state.nix
    # ./core/network.nix
    # ./core/bootloader.nix
    # ./core/libs.nix
    #
    # # Services
    # ./services/docker.nix
    # ./services/power.nix
    #
    # # Configs
    # ./configs/system-packages.nix
    ./configs/user-groups.nix
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
