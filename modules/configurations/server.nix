{config, ...}: {
  flake.modules.combined.server = {lib, ...}: {
    imports = with config.flake.modules.combined; [
      nix-settings
      state
      network
      libs
      docker
      power
      system-packages
      user-groups
      bootloader
    ];

    time.timeZone = "Europe/Copenhagen";

    i18n.defaultLocale = "en_US.UTF-8";

    services.openssh = {
      enable = lib.mkDefault true;
      settings = {
        X11Forwarding = lib.mkDefault true;
        PermitRootLogin = lib.mkForce "no";
        PasswordAuthentication = lib.mkDefault false;
      };
      openFirewall = lib.mkDefault true;
    };
  };
}
