{...}: {
  services = {
    # https://nixos.wiki/wiki/Power_management#Power_management_with_systemd
    power-profiles-daemon = {
      enable = true;
    };
    upower.enable = true;
  };
}
