{pkgs, ...}: {
  environment.systemPackages = with pkgs; [speedtest-cli bandwhich];

  networking = {
    nameservers = ["1.1.1.1" "1.0.0.1"];

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
}
