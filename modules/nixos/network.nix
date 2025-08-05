{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    speedtest-cli
    bandwhich
    wirelesstools
  ];

  networking = {
    enableIPv6 = false;

    nameservers = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];

    firewall = {
      enable = true;
      allowPing = true;
      logReversePathDrops = true;
    };

    networkmanager = {
      enable = true;
      unmanaged = ["docker0"];
    };
  };

  # Can speed up boot times
  systemd.services.NetworkManager-wait-online.enable = false;

  # services.resolved = {
  #   enable = true;
  #   dnssec = "true";
  #   domains = ["~."];
  #   fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
  #   dnsovertls = "true";
  # };
}
