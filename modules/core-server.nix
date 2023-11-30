{
  lib,
  ...
}: {
	imports = [
		./services/docker.nix
		./configs/system-packages.nix
	];

  boot.loader.systemd-boot.configurationLimit = lib.mkDefault 10;

  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  nix.settings = {
    # Manual optimise storage: nix-store --optimise
    # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
    auto-optimise-store = true;
    builders-use-substitutes = true;
    # enable flakes globally
    experimental-features = ["nix-command" "flakes"];
  };

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Copenhagen";

  i18n.defaultLocale = "en_US.UTF-8";

  networking.firewall.enable = lib.mkDefault true;

  services.openssh = {
    enable = lib.mkDefault true;
    settings = {
      X11Forwarding = lib.mkDefault true;
      PermitRootLogin = lib.mkDefault "no";
      PasswordAuthentication = lib.mkDefault false;
    };
    openFirewall = lib.mkDefault true;
  };

  services = {
    # https://nixos.wiki/wiki/Power_management#Power_management_with_systemd
    power-profiles-daemon = {
      enable = true;
    };
    upower.enable = true;
  };
}
